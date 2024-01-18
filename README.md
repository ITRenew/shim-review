This repo is for review of requests for signing shim.  To create a request for review:

- clone this repo
- edit the template below
- add the shim.efi to be signed
- add build logs
- add any additional binaries/certificates/SHA256 hashes that may be needed
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push that to github
- file an issue at https://github.com/rhboot/shim-review/issues with a link to your tag
- approval is ready when the "accepted" label is added to your issue

Note that we really only have experience with using GRUB2 on Linux, so asking
us to endorse anything else for signing is going to require some convincing on
your part.

Here's the template:

*******************************************************************************
### What organization or people are asking to have this signed?
*******************************************************************************
ITRenew Inc

*******************************************************************************
### What product or service is this for?
*******************************************************************************
Teraware is a scalable custom data sanitization tool that can be deployed on a variety of platforms and architectures.
It comprises an application layer server and a bootable agent that are built to handle a plethora of configurations, from
single devices to server farms and data centers via one installation.

*******************************************************************************
### What's the justification that this really does need to be signed for the whole world to be able to boot it?
*******************************************************************************
The Teraware is used by our enterprise, SMB and home customers to process a wide of different models of laptops/PCs/servers.
The deployment process is fully automated for these customers. Most of the hardware has Secure Boot enabled by default and may not be disabled in some instances.
We are not able to reuse SHIM/GRUB/Kernel from Redhat, or any other distribution, because Teraware software has custom patches for storage drivers.
The Linux Kernel must be built and signed with our EV certificate.
To establish the full chain of trust we also have to rebuild and sign the SHIM and GRUB loader.

*******************************************************************************
### Why are you unable to reuse shim from another distro that is already signed?
*******************************************************************************
We are unable to reuse SHIM from another distro because Teraware software contains custom patches for storage drivers that don't exist in the kernel upstream.

*******************************************************************************
### Who is the primary contact for security updates, etc.?
The security contacts need to be verified before the shim can be accepted. For subsequent requests, contact verification is only necessary if the security contacts or their PGP keys have changed since the last successful verification.

An authorized reviewer will initiate contact verification by sending each security contact a PGP-encrypted email containing random words.
You will be asked to post the contents of these mails in your `shim-review` issue to prove ownership of the email addresses and PGP keys.
*******************************************************************************
- Name:David Friedman
- Position: Senior Manager, IT
- Email address:david.friedman@ironmountain.com
- PGP key fingerprint: B2C6438FFDE5A3AAFB8CE3BEA3CD579F25D41BC3

(Key should be signed by the other security contacts, pushed to a keyserver
like keyserver.ubuntu.com, and preferably have signatures that are reasonably
well known in the Linux community.)

*******************************************************************************
### Who is the secondary contact for security updates, etc.?
*******************************************************************************
- Name:Keith LoPresto
- Position:Software Development Manager
- Email address:keithd.lopresto@ironmountain.com
- PGP key fingerprint: 85F2F52063ABD45CF77E75D4A9FA571827D09E89

(Key should be signed by the other security contacts, pushed to a keyserver
like keyserver.ubuntu.com, and preferably have signatures that are reasonably
well known in the Linux community.)

*******************************************************************************
### Were these binaries created from the 15.7 shim release tar?
Please create your shim binaries starting with the 15.7 shim release tar file: https://github.com/rhboot/shim/releases/download/15.7/shim-15.7.tar.bz2

This matches https://github.com/rhboot/shim/releases/tag/15.7 and contains the appropriate gnu-efi source.

*******************************************************************************
yes

*******************************************************************************
### URL for a repo that contains the exact code which was built to get this binary:
*******************************************************************************

https://github.com/rhboot/shim/releases/tag/15.7

*******************************************************************************
### What patches are being applied and why:
*******************************************************************************
'Make sbat_var.S parse right with buggy gcc/binutils #535' patch has been applied from the commit: https://github.com/rhboot/shim/commit/657b2483ca6e9fcf2ad8ac7ee577ff546d24c3aa

We applied this patch because our build system is based on Debian 11 and this OS uses binutils version 2.35.2. 
Versions prior to 2.36 result in a problem in generating .sbatlevel section.

*******************************************************************************
### If shim is loading GRUB2 bootloader what exact implementation of Secureboot in GRUB2 do you have? (Either Upstream GRUB2 shim_lock verifier or Downstream RHEL/Fedora/Debian/Canonical-like implementation)
*******************************************************************************
We use the upstream GRUB2 shim_lock verifier.

*******************************************************************************
### If shim is loading GRUB2 bootloader and your previously released shim booted a version of grub affected by any of the CVEs in the July 2020 grub2 CVE list, the March 2021 grub2 CVE list, the June 7th 2022 grub2 CVE list, or the November 15th 2022 list, have fixes for all these CVEs been applied?

* CVE-2020-14372
* CVE-2020-25632
* CVE-2020-25647
* CVE-2020-27749
* CVE-2020-27779
* CVE-2021-20225
* CVE-2021-20233
* CVE-2020-10713
* CVE-2020-14308
* CVE-2020-14309
* CVE-2020-14310
* CVE-2020-14311
* CVE-2020-15705
* CVE-2021-3418 (if you are shipping the shim_lock module)

* CVE-2021-3695
* CVE-2021-3696
* CVE-2021-3697
* CVE-2022-28733
* CVE-2022-28734
* CVE-2022-28735
* CVE-2022-28736
* CVE-2022-28737

* CVE-2022-2601
* CVE-2022-3775
*******************************************************************************
Yes

*******************************************************************************
### If these fixes have been applied, have you set the global SBAT generation on your GRUB binary to 3?
*******************************************************************************
Yes

*******************************************************************************
### Were old shims hashes provided to Microsoft for verification and to be added to future DBX updates?
### Does your new chain of trust disallow booting old GRUB2 builds affected by the CVEs?
*******************************************************************************
No previous shim existed for the Teraware product.  This is a new shim submission.

*******************************************************************************
### If your boot chain of trust includes a Linux kernel:
### Is upstream commit [1957a85b0032a81e6482ca4aab883643b8dae06e "efi: Restrict efivar_ssdt_load when the kernel is locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1957a85b0032a81e6482ca4aab883643b8dae06e) applied?
### Is upstream commit [75b0cea7bf307f362057cc778efe89af4c615354 "ACPI: configfs: Disallow loading ACPI tables when locked down"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=75b0cea7bf307f362057cc778efe89af4c615354) applied?
### Is upstream commit [eadb2f47a3ced5c64b23b90fd2a3463f63726066 "lockdown: also lock down previous kgdb use"](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eadb2f47a3ced5c64b23b90fd2a3463f63726066) applied?
*******************************************************************************
Yes, all these have been applied.

*******************************************************************************
### Do you build your signed kernel with additional local patches? What do they do?
*******************************************************************************
Yes. Local patches has been applied to storage drivers: aacraid, megaraid_sas, smartpqi, nvme-core, hpsa.
These patches resolves performance and storage device compatibility problems using low-level access to storage devices and disk drives.
These patches don't exist in the upstream kernel.

*******************************************************************************
### If you use vendor_db functionality of providing multiple certificates and/or hashes please briefly describe your certificate setup.
### If there are allow-listed hashes please provide exact binaries for which hashes are created via file sharing service, available in public with anonymous access for verification.
*******************************************************************************
The new vendor_db functionality is not used.

*******************************************************************************
### If you are re-using a previously used (CA) certificate, you will need to add the hashes of the previous GRUB2 binaries exposed to the CVEs to vendor_dbx in shim in order to prevent GRUB2 from being able to chainload those older GRUB2 binaries. If you are changing to a new (CA) certificate, this does not apply.
### Please describe your strategy.
*******************************************************************************
This is our initial SHIM submission and we are using a new EV certificate.  No previously used certificates.

*******************************************************************************
### What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as closely as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
### If the shim binaries can't be reproduced using the provided Dockerfile, please explain why that's the case and what the differences would be.
*******************************************************************************
Dockerfile provided.
Binaries may be reproduced with command: 

`docker build --no-cache --tag=shim-review-itrenew .`

*******************************************************************************
### Which files in this repo are the logs for your build?
This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
*******************************************************************************
'build.log' is a log file for our build.

It was produced with command:
`docker build --no-cache --progress=plain --tag=shim-review-itrenew . &> build.log`

*******************************************************************************
### What changes were made since your SHIM was last signed?
*******************************************************************************
None. Initial shim creation and review submission

*******************************************************************************
### What is the SHA256 hash of your final SHIM binary?
*******************************************************************************
092498ad40bf7da13f72a4649e1c41abf45a76659a8a825e23e1594df7030425  shimx64.efi
150eda5b87d49c41267b75d5932a18a1c72e736bd009e00a6ca37ffe9e3f8e55  shimia32.efi

*******************************************************************************
### How do you manage and protect the keys used in your SHIM?
*******************************************************************************
The key is stored on a FIPS-140-2 token with restricted physical access to authorized personnel only.

*******************************************************************************
### Do you use EV certificates as embedded certificates in the SHIM?
*******************************************************************************
Yes. 3 years validity EV certificate issued by Sectigo Limited.

*******************************************************************************
### Do you add a vendor-specific SBAT entry to the SBAT section in each binary that supports SBAT metadata ( grub2, fwupd, fwupdate, shim + all child shim binaries )?
### Please provide exact SBAT entries for all SBAT binaries you are booting or planning to boot directly through shim.
### Where your code is only slightly modified from an upstream vendor's, please also preserve their SBAT entries to simplify revocation.
*******************************************************************************
SHIM:
```
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
shim,3,UEFI shim,shim,1,https://github.com/rhboot/shim
shim.itrenew,1,ITrenew Inc.,shim,15.7,mail:security@itrenew.com
```
GRUB2:
```
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
grub,3,Free Software Foundation,grub,2.06,https//www.gnu.org/software/grub/
grub.itrenew,1,ITrenew Inc.,grub2,2.06-65bc4596,mail:security@itrenew.com
```

*******************************************************************************
### Which modules are built into your signed grub image?
*******************************************************************************
all_video boot chain configfile echo ext2 exfat fat font
gfxmenu gfxterm gfxterm_background
gzio halt iso9660 jpeg linux loadenv loopback lvm
memdisk normal ntfs part_gpt
part_msdos png probe reboot
search search_fs_file search_fs_uuid search_label test
tpm true video xfs

*******************************************************************************
### What is the origin and full version number of your bootloader (GRUB or other)?
*******************************************************************************
We use upstream GRUB2 bootloader from:
https://git.savannah.gnu.org/git/grub.git

Commit: 65bc45963014773e2062ccc63ff34a089d2e352e

*******************************************************************************
### If your SHIM launches any other components, please provide further details on what is launched.
*******************************************************************************
Shim used to launch GRUB only

*******************************************************************************
### If your GRUB2 launches any other binaries that are not the Linux kernel in SecureBoot mode, please provide further details on what is launched and how it enforces Secureboot lockdown.
*******************************************************************************
GRUB only launches the linux kernel

*******************************************************************************
### How do the launched components prevent execution of unauthenticated code?
*******************************************************************************
UEFI firmware with Secure Boot enabled will trust to SHIM that will be signed by Microsoft.
This SHIM has our company EV certificate embedded.
SHIM verifies GRUB bootloader that is signed using our company EV certificate and allows to boot only this GRUB bootloader.
GRUB verifies Linux Kernel using the 'shim_lock' verifier and only allows booting of the kernel signed using our EV certificate.
Linux Kernel is built with lockdown support and option CONFIG_MODULE_SIG_FORCE enabled to enforce checking of modules signature.
All modules we build are signed with our EV certificate.

The above steps establish the full chain of trust. 

*******************************************************************************
### Does your SHIM load any loaders that support loading unsigned kernels (e.g. GRUB)?
*******************************************************************************
No, GRUB uses the 'shim_lock' verifier to ensure that only kernels signed by us are loaded.

*******************************************************************************
### What kernel are you using? Which patches does it includes to enforce Secure Boot?
*******************************************************************************
We use Linux Kernel 5.15.70.
This kernel already has all lockdown patches applied.

*******************************************************************************
### Add any additional information you think we may need to validate this shim.
*******************************************************************************
None
