FROM debian:bullseye

RUN echo "deb-src http://deb.debian.org/debian bullseye main" >> /etc/apt/sources.list
RUN echo "deb-src http://deb.debian.org/debian-security bullseye-security main" >> /etc/apt/sources.list
RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential git-buildpackage dos2unix

COPY *.efi /shim-review/

WORKDIR /build
RUN git clone --recursive -b 15.7 https://github.com/rhboot/shim.git shim
WORKDIR /build/shim

COPY itrenew-ev.cer /build/shim
COPY sbat.csv /build/shim/data
COPY sbat_var.S.patch /build/shim

# Apply the patch 'Make sbat_var.S parse right with buggy gcc/binutils' 
# from the commit 657b2483ca6e9fcf2ad8ac7ee577ff546d24c3aa
RUN patch -Np1 -i sbat_var.S.patch

RUN mkdir -p build-x86_64/data build-ia32/data
RUN cp /build/shim/data/sbat.csv build-x86_64/data && \
    cp /build/shim/data/sbat.csv build-ia32/data

# Build for x86_64 arch
RUN make -C build-x86_64 ARCH=x86_64 VENDOR_CERT_FILE=/build/shim/itrenew-ev.cer TOPDIR=.. -f ../Makefile
# Build for ia32 arch
RUN make -C build-ia32 ARCH=ia32 VENDOR_CERT_FILE=/build/shim/itrenew-ev.cer TOPDIR=.. -f ../Makefile

### Enable NX compatibility flag as required by https://github.com/rhboot/shim-review/issues/307
### Update: Temporary disabled setting of NX compatibility flag due to changed requirements. 
# RUN ./build-x86_64/post-process-pe -vv -n build-x86_64/shimx64.efi
# RUN ./build-ia32/post-process-pe -vv -n build-ia32/shimia32.efi

# Copy binary targets
RUN mkdir /build/target/
RUN cp build-x86_64/shimx64.efi /build/target && \
    cp build-ia32/shimia32.efi /build/target

# Check if SBAT is compiled into targets correctly
RUN objcopy -j .sbat -O binary /build/target/shimx64.efi shimx64.sbat && \
    objcopy -j .sbat -O binary /build/target/shimia32.efi shimia32.sbat
RUN cat shimx64.sbat 
RUN cat shimia32.sbat
RUN objdump -s -j .sbatlevel /build/target/shimx64.efi && \
    objdump -s -j .sbatlevel /build/target/shimia32.efi
RUN diff shimx64.sbat /build/shim/data/sbat.csv && \
    diff shimia32.sbat /build/shim/data/sbat.csv || ( >&2 echo "Bad SBAT"; exit 1 )

# Check for original and built SHA256
RUN sha256sum /build/target/shimx64.efi /shim-review/shimx64.efi
RUN sha256sum /build/target/shimia32.efi /shim-review/shimia32.efi

RUN hexdump -Cv /build/target/shimx64.efi > shimx64-built-dump && \
    hexdump -Cv /shim-review/shimx64.efi > shimx64-orig-dump && \
    hexdump -Cv /build/target/shimia32.efi > shimia32-built-dump && \
    hexdump -Cv /shim-review/shimia32.efi > shimia32-orig-dump
RUN diff -u shimx64-built-dump shimx64-orig-dump && \
    diff -u shimia32-built-dump shimia32-orig-dump || ( >&2 echo "Target binaries are not the same as original"; exit 1 )
