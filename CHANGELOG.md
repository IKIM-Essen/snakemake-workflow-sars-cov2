# Changelog

## [1.1.2](https://github.com/IKIM-Essen/uncovar/compare/v1.1.1...v1.1.2) (2024-11-07)


### Bug Fixes

* properly write to log file in order_contigs rule ([#677](https://github.com/IKIM-Essen/uncovar/issues/677)) ([093fb55](https://github.com/IKIM-Essen/uncovar/commit/093fb55522b3c598256e8fc53b96f9bb9b2882c5))
* update pangolin to 4.3.1 ([#675](https://github.com/IKIM-Essen/uncovar/issues/675)) ([b16b3e3](https://github.com/IKIM-Essen/uncovar/commit/b16b3e3067e2d188227f80f1a637f76b5a8fdfab))

## [1.1.1](https://github.com/IKIM-Essen/uncovar/compare/v1.1.0...v1.1.1) (2024-11-04)


### Bug Fixes

* fix file not found error on shared fs storage ([#673](https://github.com/IKIM-Essen/uncovar/issues/673)) ([c28db96](https://github.com/IKIM-Essen/uncovar/commit/c28db9608c816cc775397096d45bd33c8e59aace))

## [1.1.0](https://github.com/IKIM-Essen/uncovar/compare/v1.0.0...v1.1.0) (2024-10-31)


### Features

* FLiRT Mutations column ([#664](https://github.com/IKIM-Essen/uncovar/issues/664)) ([f77d42e](https://github.com/IKIM-Essen/uncovar/commit/f77d42e2154a95b6ca0e2c127df8ca134eda1789))


### Bug Fixes

* changed kraken input files for ont ([#650](https://github.com/IKIM-Essen/uncovar/issues/650)) ([b62007c](https://github.com/IKIM-Essen/uncovar/commit/b62007c7b10b9d933528a6b02933cca4bd751100))
* move primer file location under workflow; this avoids file not being found in shared filesystems ([#665](https://github.com/IKIM-Essen/uncovar/issues/665)) ([9cb1576](https://github.com/IKIM-Essen/uncovar/commit/9cb1576a8c41c23344940f2248e5d44464a53b2e))
* pangolin data updates ([#662](https://github.com/IKIM-Essen/uncovar/issues/662)) ([f46ec83](https://github.com/IKIM-Essen/uncovar/commit/f46ec833ed56c39820c0a0e8d8e0295050a334ab))
* replace ragoo with ragtag ([#591](https://github.com/IKIM-Essen/uncovar/issues/591)) ([e64e9db](https://github.com/IKIM-Essen/uncovar/commit/e64e9db7e81a295ff1775b880c255b71274448fd))

## [1.0.0](https://github.com/IKIM-Essen/uncovar/compare/v0.16.0...v1.0.0) (2024-04-17)


### Bug Fixes

* docs deployment ([#635](https://github.com/IKIM-Essen/uncovar/issues/635)) ([dd767b0](https://github.com/IKIM-Essen/uncovar/commit/dd767b0348a4a8b0736a65475339aed80e96f5cb))
* more meaningful info for patient overview table ([#609](https://github.com/IKIM-Essen/uncovar/issues/609)) ([77f7960](https://github.com/IKIM-Essen/uncovar/commit/77f796056709364d65b41126c2ee5208b56ef0d5))
* pin to varlociraptor 8.4.4 ([#634](https://github.com/IKIM-Essen/uncovar/issues/634)) ([a4e1ea8](https://github.com/IKIM-Essen/uncovar/commit/a4e1ea814fcaae5a013ad53dcafceb2c4191ad1d))
* pipe of stdout ([#631](https://github.com/IKIM-Essen/uncovar/issues/631)) ([a48a357](https://github.com/IKIM-Essen/uncovar/commit/a48a357e37590abce028216277eeb7105e205945))
* remove -r flag ([#624](https://github.com/IKIM-Essen/uncovar/issues/624)) ([4f1b56b](https://github.com/IKIM-Essen/uncovar/commit/4f1b56bf4043743c1cb63b85e433742b677a6ac8))
* update link for covariants ([#626](https://github.com/IKIM-Essen/uncovar/issues/626)) ([e6476b6](https://github.com/IKIM-Essen/uncovar/commit/e6476b6dee7d5fe1641dcba7cc83f1dcd22ea989))


### Miscellaneous Chores

* release 1.0.0 ([07d6fe2](https://github.com/IKIM-Essen/uncovar/commit/07d6fe29a99430c4b01a24aa6a4390d66ace177b))

## [0.16.0](https://github.com/IKIM-Essen/uncovar/compare/v0.15.1...v0.16.0) (2023-11-16)


### Features

* Update README.md for dark/light theme ([#614](https://github.com/IKIM-Essen/uncovar/issues/614)) ([33ac5f7](https://github.com/IKIM-Essen/uncovar/commit/33ac5f7b4f7af8bbb500e9f531ccbdc45ac9427f))


### Bug Fixes

* changes in path requirements for snakedeploy ([#590](https://github.com/IKIM-Essen/uncovar/issues/590)) ([406d456](https://github.com/IKIM-Essen/uncovar/commit/406d456edd15715f7e14338b8195d2a09a807e49))
* improved clonality event definition, usage of major subclone for assembly polishing; upgrade to varlociraptor 6.0 ([#585](https://github.com/IKIM-Essen/uncovar/issues/585)) ([aced95e](https://github.com/IKIM-Essen/uncovar/commit/aced95e798fd0483e99120550f49614e680f56dd))
* QA genome generation ([#613](https://github.com/IKIM-Essen/uncovar/issues/613)) ([2bb74bf](https://github.com/IKIM-Essen/uncovar/commit/2bb74bfc26dee80af7d04089aafe636ea7c6d76a))
* switch from jupyter notebook to script ([#598](https://github.com/IKIM-Essen/uncovar/issues/598)) ([d0f293d](https://github.com/IKIM-Essen/uncovar/commit/d0f293d2b8136fb0d8ef3753733ab1d30fb20d56))
* update multiqc ([#607](https://github.com/IKIM-Essen/uncovar/issues/607)) ([0070d89](https://github.com/IKIM-Essen/uncovar/commit/0070d8927290dd01f418b876b60f3405158f1ab9))
* use homopolymer-pair-HMM-mode of Varlociraptor in case of nanopore reads ([505a271](https://github.com/IKIM-Essen/uncovar/commit/505a2714ba0e5642312051f5e5154f7d454ff57f))
* use homopolymer-pair-HMM-mode of Varlociraptor in case of nanopore reads ([#587](https://github.com/IKIM-Essen/uncovar/issues/587)) ([9bc814f](https://github.com/IKIM-Essen/uncovar/commit/9bc814f7cb9e9d9e53d557d463e782801070b46e))


### Performance Improvements

* update to varlociraptor 8.4 ([#596](https://github.com/IKIM-Essen/uncovar/issues/596)) ([34701af](https://github.com/IKIM-Essen/uncovar/commit/34701af485aa1ec199a418ec1487a97677f624ca))

## [0.15.1](https://github.com/IKIM-Essen/uncovar/compare/v0.15.0...v0.15.1) (2022-11-30)


### Bug Fixes

* **ci:** update black to rev 22.3.0 ([#523](https://github.com/IKIM-Essen/uncovar/issues/523)) ([2273b7d](https://github.com/IKIM-Essen/uncovar/commit/2273b7d49d21dfe48812f7e3e4d33969b62e1d9e))
* disable ont actions ([#555](https://github.com/IKIM-Essen/uncovar/issues/555)) ([56e46ef](https://github.com/IKIM-Essen/uncovar/commit/56e46ef7e1663b4de3447068df7cb8b9d1d7b67f))
* Replace outdated df append ([#544](https://github.com/IKIM-Essen/uncovar/issues/544)) ([4a40003](https://github.com/IKIM-Essen/uncovar/commit/4a4000310cba4f3e8640172eadebcd35239b2e34))
* update channel priorities and snakemake wrappers ([#562](https://github.com/IKIM-Essen/uncovar/issues/562)) ([a0b6fd0](https://github.com/IKIM-Essen/uncovar/commit/a0b6fd0557b7e6cb3aeddd22e6a3350560c18415))
* use latest varlociraptor release and ignore all biases in case of known lineage variant calling ([#575](https://github.com/IKIM-Essen/uncovar/issues/575)) ([fa957fd](https://github.com/IKIM-Essen/uncovar/commit/fa957fd44594920c12df3821a23905055b1de9c9))
* voc probability ([#541](https://github.com/IKIM-Essen/uncovar/issues/541)) ([db6eb17](https://github.com/IKIM-Essen/uncovar/commit/db6eb175aa7c25948677a9b64258afd377016d8c))

## [0.15.0](https://github.com/IKIM-Essen/uncovar/compare/v0.14.0...v0.15.0) (2022-03-24)


### Features

* update rbt to 0.39 ([#510](https://github.com/IKIM-Essen/uncovar/issues/510)) ([91b5ac5](https://github.com/IKIM-Essen/uncovar/commit/91b5ac585177b127a80548235abe7469a04e97cc))


### Bug Fixes

* add nofilter flag for variant calls ([#505](https://github.com/IKIM-Essen/uncovar/issues/505)) ([381007c](https://github.com/IKIM-Essen/uncovar/commit/381007c351db1809d6c93dc337920d9e9fa3ed54))
* primer clipping add up- and downstream ([#515](https://github.com/IKIM-Essen/uncovar/issues/515)) ([5c886fa](https://github.com/IKIM-Essen/uncovar/commit/5c886fa439399c129fcec536b6d149b4e1741685))

## [0.14.0](https://github.com/IKIM-Essen/uncovar/compare/v0.13.2...v0.14.0) (2022-03-21)


### Features

* add variant call details based on protein annotation ([#487](https://github.com/IKIM-Essen/uncovar/issues/487)) ([016bcfb](https://github.com/IKIM-Essen/uncovar/commit/016bcfb3721ed31b208b29a9bdab7957be32439d))
* call known lineage variants ([#392](https://github.com/IKIM-Essen/uncovar/issues/392)) ([9ad720c](https://github.com/IKIM-Essen/uncovar/commit/9ad720c32f1b246b5ef8a20871063a05dfd682b8))
* **deps:** bump github/super-linter from 4.8.6 to 4.8.7 ([#459](https://github.com/IKIM-Essen/uncovar/issues/459)) ([c18f241](https://github.com/IKIM-Essen/uncovar/commit/c18f2412f576b26050e3296bdcc509cd5facf462))
* **deps:** update pangolin to 3.1.19 ([#461](https://github.com/IKIM-Essen/uncovar/issues/461)) ([3971687](https://github.com/IKIM-Essen/uncovar/commit/3971687db229577fa862b40f900701f18270011d))
* **deps:** update pangolin to 3.1.19 ([#461](https://github.com/IKIM-Essen/uncovar/issues/461)) ([d5f42ca](https://github.com/IKIM-Essen/uncovar/commit/d5f42ca229c038adaf0ccb1ce772aaa4e229b1fe))
* **deps:** update pangolin to 3.1.20 ([#467](https://github.com/IKIM-Essen/uncovar/issues/467)) ([78cb7f4](https://github.com/IKIM-Essen/uncovar/commit/78cb7f4452fe703194aed2fb393649572b60519c))
* make incoming and archive structure data-handling optional ([#443](https://github.com/IKIM-Essen/uncovar/issues/443)) ([559e9c1](https://github.com/IKIM-Essen/uncovar/commit/559e9c1c1af503398a1669fd0e4f04e7d4b4a7ac))
* make sending lab column in rki report csv adjustable via config file ([#492](https://github.com/IKIM-Essen/uncovar/issues/492)) ([311e857](https://github.com/IKIM-Essen/uncovar/commit/311e8578a7d9956ffb532314da60b01211a90b60))
* rule and script bed_to_bedpe ([#447](https://github.com/IKIM-Essen/uncovar/issues/447)) ([3022eab](https://github.com/IKIM-Essen/uncovar/commit/3022eab0854992fb40894c7b1dd0feca8400b2fc))


### Bug Fixes

* add missing fasta index to vcf report ([#480](https://github.com/IKIM-Essen/uncovar/issues/480)) ([1697fb5](https://github.com/IKIM-Essen/uncovar/commit/1697fb50b2e4b3d249c4a83e83ecab2876118a91))
* add missing voc variant report to environmental report ([#479](https://github.com/IKIM-Essen/uncovar/issues/479)) ([16baef1](https://github.com/IKIM-Essen/uncovar/commit/16baef1c440dbf6e059b81d2c3f7f100c53ee692))
* bump rust-bio-tools to 0.38 ([#449](https://github.com/IKIM-Essen/uncovar/issues/449)) ([e85fa15](https://github.com/IKIM-Essen/uncovar/commit/e85fa15f0489185b9fc7a851005da1078c06c3fb))
* canu and porechop logging ([5db0935](https://github.com/IKIM-Essen/uncovar/commit/5db09352abdcb2af41ae5b72250b26c547951877))
* canu and porechop logs ([#473](https://github.com/IKIM-Essen/uncovar/issues/473)) ([497bfcd](https://github.com/IKIM-Essen/uncovar/commit/497bfcdd1bda588209295e7cc3e7d3acf20a2182))
* **ci:** add missing missing echo to release please ([#476](https://github.com/IKIM-Essen/uncovar/issues/476)) ([6a0b899](https://github.com/IKIM-Essen/uncovar/commit/6a0b899454883d6c53c4234f2b356f20ac503249))
* **ci:** change human reference from NC_000021.9 to BA000005.3 ([#488](https://github.com/IKIM-Essen/uncovar/issues/488)) ([14b4be0](https://github.com/IKIM-Essen/uncovar/commit/14b4be01ee1ff586b0e12d13b15c254d739e260b))
* **ci:** change release please PR branch ([#481](https://github.com/IKIM-Essen/uncovar/issues/481)) ([603d3b5](https://github.com/IKIM-Essen/uncovar/commit/603d3b5edfbc7864e279950f8981c534397105d9))
* **ci:** parse new json output from release please ([#474](https://github.com/IKIM-Essen/uncovar/issues/474)) ([eb598b7](https://github.com/IKIM-Essen/uncovar/commit/eb598b7f4feb51d8d5679dc2ef0aa823a7127a52))
* **ci:** release please checkout branch ([#477](https://github.com/IKIM-Essen/uncovar/issues/477)) ([03a69bf](https://github.com/IKIM-Essen/uncovar/commit/03a69bfe23097222cf88f43f15d4b40b5f4fb3de))
* correct filtering in plot-lineages-over-time ([#445](https://github.com/IKIM-Essen/uncovar/issues/445)) ([c71f72b](https://github.com/IKIM-Essen/uncovar/commit/c71f72bad90cc32923b7de6ffcc6de66367cf6ff))
* **deps:** update multiqc wrapper ([#329](https://github.com/IKIM-Essen/uncovar/issues/329)) ([42fbcd8](https://github.com/IKIM-Essen/uncovar/commit/42fbcd8bc442d5c1e2142fc6c14406819c2b63bb))
* fixed include flag KeyError ([#452](https://github.com/IKIM-Essen/uncovar/issues/452)) ([f47dad2](https://github.com/IKIM-Essen/uncovar/commit/f47dad20891a447e202aa2ff3f1712b77daaa593))
* order of include flag sample ([#462](https://github.com/IKIM-Essen/uncovar/issues/462)) ([429e5d9](https://github.com/IKIM-Essen/uncovar/commit/429e5d9447b64dfbd20bcfaa924feb5fae7ddfb9))
* pangolin plot color ([#483](https://github.com/IKIM-Essen/uncovar/issues/483)) ([9e368d5](https://github.com/IKIM-Essen/uncovar/commit/9e368d572abfb4816f8a3270b8deb22c198234ad))
* reduce loading time of coverage plots ([#498](https://github.com/IKIM-Essen/uncovar/issues/498)) ([8a8f533](https://github.com/IKIM-Essen/uncovar/commit/8a8f53347aa90c66075c1418e9cdf34bbecc02bc))
* remove removal of .indicators/replacement_notice.txt for int ([#457](https://github.com/IKIM-Essen/uncovar/issues/457)) ([c5b9f6c](https://github.com/IKIM-Essen/uncovar/commit/c5b9f6c02c6e65646d0bc748cef5962b56322b3e))
* rename column header in report formatter ([#444](https://github.com/IKIM-Essen/uncovar/issues/444)) ([8ba21d9](https://github.com/IKIM-Essen/uncovar/commit/8ba21d90caa0e312e4619fc02e1a38f84039805b))
* reset over table formatter ([#448](https://github.com/IKIM-Essen/uncovar/issues/448)) ([ee30a46](https://github.com/IKIM-Essen/uncovar/commit/ee30a46bc966413fbd1f8d616a3f1f97b356ff72))
* untmp recalibrated bam ([#491](https://github.com/IKIM-Essen/uncovar/issues/491)) ([1118fd9](https://github.com/IKIM-Essen/uncovar/commit/1118fd91a815f002188ba9969ece6a159279953a))
* VOC mutation table similarity calculation ([#484](https://github.com/IKIM-Essen/uncovar/issues/484)) ([82405ee](https://github.com/IKIM-Essen/uncovar/commit/82405ee8e1d0eddcf40315888ef3a32eda7b3954))


### Performance Improvements

* add ont temp flags ([#475](https://github.com/IKIM-Essen/uncovar/issues/475)) ([6447583](https://github.com/IKIM-Essen/uncovar/commit/6447583800b756c573bcf959d14d0d6f29eebd21))
* ont downsampling normalisation ([#489](https://github.com/IKIM-Essen/uncovar/issues/489)) ([f502dd2](https://github.com/IKIM-Essen/uncovar/commit/f502dd287be37c76997f44054389124494e23ab7))
* optimisations for ont - barcode+adapter-trimming, primer-trimming (porechop) and read correction (Canu) ([#454](https://github.com/IKIM-Essen/uncovar/issues/454)) ([e844fc4](https://github.com/IKIM-Essen/uncovar/commit/e844fc40923fcaa8c680079a05cd09173027fb00))

### [0.13.2](https://github.com/IKIM-Essen/uncovar/compare/v0.13.1...v0.13.2) (2022-01-06)


### Bug Fixes

* wrong enumeration with kallisto included ([#439](https://github.com/IKIM-Essen/uncovar/issues/439)) ([1a68969](https://github.com/IKIM-Essen/uncovar/commit/1a6896926c4f38d897541a6d38dc874d54b57176))

### [0.13.1](https://github.com/IKIM-Essen/uncovar/compare/v0.13.0...v0.13.1) (2022-01-04)


### Bug Fixes

* relative aggregation sample plot ([#412](https://github.com/IKIM-Essen/uncovar/issues/412)) ([6a8155e](https://github.com/IKIM-Essen/uncovar/commit/6a8155ec0b227da9907fb709c909afdb35571375))

## [0.13.0](https://github.com/IKIM-Essen/uncovar/compare/v0.12.0...v0.13.0) (2022-01-03)


### Features

* add optional column for adapters ([#419](https://github.com/IKIM-Essen/uncovar/issues/419)) ([f883ce2](https://github.com/IKIM-Essen/uncovar/commit/f883ce24231d3e249c1c3a2798ad5c42cd954342))
* add patient or environmental mode flag ([#420](https://github.com/IKIM-Essen/uncovar/issues/420)) ([9ac2002](https://github.com/IKIM-Essen/uncovar/commit/9ac2002e733ecd215e89f5043409c4ab90d9064b))
* add prettier to pre-commit ([#427](https://github.com/IKIM-Essen/uncovar/issues/427)) ([e7cb0a7](https://github.com/IKIM-Essen/uncovar/commit/e7cb0a7a6de37b767befb314bdd32828437c53b7))


### Bug Fixes

* generate high quality report .csv file ([#433](https://github.com/IKIM-Essen/uncovar/issues/433)) ([077b80d](https://github.com/IKIM-Essen/uncovar/commit/077b80d2b2b00026fc9944a26c0183505f9060cf))

## [0.12.0](https://www.github.com/IKIM-Essen/uncovar/compare/v0.11.0...v0.12.0) (2021-12-23)


### Features

* add varlociraptor test case generation ([#429](https://www.github.com/IKIM-Essen/uncovar/issues/429)) ([3ec7975](https://www.github.com/IKIM-Essen/uncovar/commit/3ec79756226500f2e686c1f5e7ed83d50de545c3))


### Bug Fixes

* update the mutations columns in the overview table formatter ([#423](https://www.github.com/IKIM-Essen/uncovar/issues/423)) ([3af43b9](https://www.github.com/IKIM-Essen/uncovar/commit/3af43b991af218931996d9093ecf944bff907476))

## [0.11.0](https://www.github.com/IKIM-Essen/uncovar/compare/v0.10.2...v0.11.0) (2021-12-21)


### Features

* update to rust-bio-tools 0.33 ([#388](https://www.github.com/IKIM-Essen/uncovar/issues/388)) ([8f66915](https://www.github.com/IKIM-Essen/uncovar/commit/8f669159d7db8dad503cccf505c34a8271795bcd))
* update to varlociraptor 4.9 ([#424](https://www.github.com/IKIM-Essen/uncovar/issues/424)) ([5a7ca5b](https://www.github.com/IKIM-Essen/uncovar/commit/5a7ca5be08afdc6642a0db103c9fec2f6842fc53))

### [0.10.2](https://www.github.com/IKIM-Essen/uncovar/compare/v0.10.1...v0.10.2) (2021-12-19)


### Bug Fixes

* pangolin input for overview table, bamclipper samtools error, include flag for high quality genome report ([#418](https://www.github.com/IKIM-Essen/uncovar/issues/418)) ([9690f12](https://www.github.com/IKIM-Essen/uncovar/commit/9690f12e6725447e035903d3b4eecf31d01b1576))

### [0.10.1](https://www.github.com/IKIM-Essen/uncovar/compare/v0.10.0...v0.10.1) (2021-12-17)


### Bug Fixes

* names in report ([#410](https://www.github.com/IKIM-Essen/uncovar/issues/410)) ([e5dbcbd](https://www.github.com/IKIM-Essen/uncovar/commit/e5dbcbd61fc836e8705a08ac189235c78fd1db65))

## [0.10.0](https://www.github.com/IKIM-Essen/uncovar/compare/v0.9.0...v0.10.0) (2021-12-16)


### Features

* complete workflow if no samples pass the quality filter ([#411](https://www.github.com/IKIM-Essen/uncovar/issues/411)) ([55b2dcc](https://www.github.com/IKIM-Essen/uncovar/commit/55b2dcce83c6349b4651c07acfda2cfe885ed0f6))

## [0.9.0](https://www.github.com/IKIM-Essen/uncovar/compare/v0.8.0...v0.9.0) (2021-12-15)


### Features

* added variants-over-time-plot to report again ([#405](https://www.github.com/IKIM-Essen/uncovar/issues/405)) ([bd5048a](https://www.github.com/IKIM-Essen/uncovar/commit/bd5048af11d3f1f28a1853a9ec1070fe85ff977b))

## [0.8.0](https://www.github.com/IKIM-Essen/uncovar/compare/v0.7.0...v0.8.0) (2021-12-15)


### Features

* add pangolin call table ([#397](https://www.github.com/IKIM-Essen/uncovar/issues/397)) ([953211a](https://www.github.com/IKIM-Essen/uncovar/commit/953211a552f0ce84594e598318cc25a7d406c3cd))
* add rki include/exclude flag ([#319](https://www.github.com/IKIM-Essen/uncovar/issues/319)) ([d2e6d20](https://www.github.com/IKIM-Essen/uncovar/commit/d2e6d20de0429323989d107eac5c4282561b57ce))
* added column in overview table for the clear name of the lineage ([#400](https://www.github.com/IKIM-Essen/uncovar/issues/400)) ([38e34bb](https://www.github.com/IKIM-Essen/uncovar/commit/38e34bba65ab28481466e5897019f060d57596f8))


### Bug Fixes

* change report structure, add masked sequence, pangolin call on polished sequence ([#396](https://www.github.com/IKIM-Essen/uncovar/issues/396)) ([d2ecaaa](https://www.github.com/IKIM-Essen/uncovar/commit/d2ecaaa55efaf916fe380f042758f1560a5b389f))
* rmv pipe from pre-commit ([#401](https://www.github.com/IKIM-Essen/uncovar/issues/401)) ([3222bb2](https://www.github.com/IKIM-Essen/uncovar/commit/3222bb2220ce517ba514f28f416c730ef884d52f))

## [0.7.0](https://www.github.com/IKIM-Essen/uncovar/compare/v0.6.0...v0.7.0) (2021-12-14)


### Features

* add pre commit checks ([#398](https://www.github.com/IKIM-Essen/uncovar/issues/398)) ([6982b3d](https://www.github.com/IKIM-Essen/uncovar/commit/6982b3dcaca308840d9a70caec22e79bdb9025fc))


### Bug Fixes

* remove cwd-check in update sample sheet script ([#393](https://www.github.com/IKIM-Essen/uncovar/issues/393)) ([44d49d3](https://www.github.com/IKIM-Essen/uncovar/commit/44d49d34e7ed2ad94002ed9b9e8868ec9665a541))
* trigger docs build on release created ([#391](https://www.github.com/IKIM-Essen/uncovar/issues/391)) ([e240aeb](https://www.github.com/IKIM-Essen/uncovar/commit/e240aeb5f13d38a2ccf14ce1cb2277af197d9117))

## [0.6.0](https://www.github.com/IKIM-Essen/uncovar/compare/v0.5.0...v0.6.0) (2021-12-13)


### Features

* update pangolin to 3.1.17 ([#389](https://www.github.com/IKIM-Essen/uncovar/issues/389)) ([23ed39e](https://www.github.com/IKIM-Essen/uncovar/commit/23ed39e6b7471a7f4efc649efb51882cf692e125))
* update varlociraptor to version 4.8 ([#331](https://www.github.com/IKIM-Essen/uncovar/issues/331)) ([0096376](https://www.github.com/IKIM-Essen/uncovar/commit/009637621a3f55b8852c2aa9b428775f1286f40b))


### Bug Fixes

* generation of high quality genomes ([#394](https://www.github.com/IKIM-Essen/uncovar/issues/394)) ([da00975](https://www.github.com/IKIM-Essen/uncovar/commit/da00975893a20144c28cf4185c9263f6bd6c5a7c))
* relative aggregation of samples for variants and lineages over time plots ([#382](https://www.github.com/IKIM-Essen/uncovar/issues/382)) ([ebe556c](https://www.github.com/IKIM-Essen/uncovar/commit/ebe556c3dfa7d1bbf6797d51452d06e53184f679))

## [0.5.0](https://www.github.com/IKIM-Essen/uncovar/compare/v0.4.1...v0.5.0) (2021-12-09)


### Features

* **technology:** add ion torrent processing ([#383](https://www.github.com/IKIM-Essen/uncovar/issues/383)) ([288777c](https://www.github.com/IKIM-Essen/uncovar/commit/288777cef21485fb0365c5c552690f2bf94b6e11))

### [0.4.1](https://www.github.com/IKIM-Essen/uncovar/compare/v0.4.0...v0.4.1) (2021-12-07)


### Bug Fixes

* **ci:** adjust commit message of copyright-preamble.yml to fit conventional commits format ([#369](https://www.github.com/IKIM-Essen/uncovar/issues/369)) ([e067895](https://www.github.com/IKIM-Essen/uncovar/commit/e067895adc368414000cba5e4db73edbb3d03b95))
* GISAID lineage extraction [B.1.1.529 (probably).fasta] ([#372](https://www.github.com/IKIM-Essen/uncovar/issues/372)) ([7750862](https://www.github.com/IKIM-Essen/uncovar/commit/7750862a98890937885164b469b5f487ae70488a))

## [0.4.0](https://www.github.com/IKIM-Essen/uncovar/compare/v0.3.1...v0.4.0) (2021-12-02)


### Features

* **technology:** add Oxford Nanopore processing ([#305](https://www.github.com/IKIM-Essen/uncovar/issues/305)) ([55f38f3](https://www.github.com/IKIM-Essen/uncovar/commit/55f38f3f94146355c245f76d6c210dbf351a6eaf))


### Bug Fixes

* add bam index for extract_reads_of_interest ([#366](https://www.github.com/IKIM-Essen/uncovar/issues/366)) ([5f5dd27](https://www.github.com/IKIM-Essen/uncovar/commit/5f5dd27311d1bc27787b2061bba2312a50fbf720))
* changed contigs file for quast-rule to avoid workflow to stop because of low read numbers ([#338](https://www.github.com/IKIM-Essen/uncovar/issues/338)) ([2d0e246](https://www.github.com/IKIM-Essen/uncovar/commit/2d0e2465217470f0e9f089b9c3e240cddfc6336e))
* changed JSON schema validator and updated files [#364](https://www.github.com/IKIM-Essen/uncovar/issues/364) ([75e62f2](https://www.github.com/IKIM-Essen/uncovar/commit/75e62f20b88eaeb19389908e325b264b0f64081d))


### Performance Improvements

* changed chunksize of read json file from gisaid, excluded lineage without name ([#328](https://www.github.com/IKIM-Essen/uncovar/issues/328)) ([b9e5c49](https://www.github.com/IKIM-Essen/uncovar/commit/b9e5c49dbf8910ad0332a73dba0c027bf3545c81))

### [0.3.1](https://www.github.com/IKIM-Essen/uncovar/compare/v0.3.0...v0.3.1) (2021-11-29)


### Bug Fixes

* nested function usage and remove code duplication ([#323](https://www.github.com/IKIM-Essen/uncovar/issues/323)) ([91e3ce9](https://www.github.com/IKIM-Essen/uncovar/commit/91e3ce922132309d3d226a9efceb995ce99b4489))

## [0.3.0](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/compare/v0.2.5...v0.3.0) (2021-11-05)


### Features

* add aggregation rule for publication plots ([#275](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/275)) ([a93bc18](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/a93bc18bae5976bcdb045d8daab6760e03e3a6ea))
* add more voc mutations to config ([#314](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/314)) ([5098605](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/509860512f819887cfcb15786f127157382d5b29))
* add plot of reads needed for sufficient lineage calling ([#263](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/263)) ([982f997](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/982f997b73fa110babde87cf9bea0406350fb0e7))
* add plot of variants over time ([#279](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/279)) ([66ab121](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/66ab12115814597a569a9662cba51ac679b1a81d))
* add schemes for sample sheet and config file ([#278](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/278)) ([09976b3](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/09976b3b901f224374cc9baa3df1a65eed89822c))
* add standard reference lineages for kallisto based lineage calling ([#280](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/280)) ([6bb32f6](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/6bb32f6cda5cddf6cb598e566bbee9b2af26f190))
* add todo action ([#277](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/277)) ([c1e44c5](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/c1e44c5ee2ad7c9bd2b9cbf5182616a36c50a38d))
* add workflow catalog yml ([#199](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/199)) ([2013533](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/20135333faf2247f2a11e3201d362125de53e3b4))
* comparison of assemblers ([#172](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/172)) ([8233829](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/8233829467b9cfaa45291225d05a8d6e34da044c))


### Bug Fixes

* add "snakemake" in the readme for the Snakemake Workflow Catalog requirements ([#309](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/309)) ([2e5212c](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/2e5212c08604cc4b61704fc07711d00f964078d1))
* changed call config file in update-sample-sheet ([#307](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/307)) ([406aef7](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/406aef7ae411cc13ef9b1df3892922862104d01d))
* shotgun typo in config.yaml  ([#308](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/308)) ([d30f02b](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/d30f02b756699647bfbdcce802a33442bf324a76))
* specify snakemake version used in pangolin env ([#284](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/284)) ([79a12a8](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/79a12a8fbecb0a83f263779880f9384cecf57529))

### [0.2.5](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/compare/v0.2.4...v0.2.5) (2021-09-23)


### Bug Fixes

* sha tag name ([#273](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/273)) ([b6d1265](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/b6d126582c630d64341ac18f18c982a584022f7e))

### [0.2.4](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/compare/v0.2.3...v0.2.4) (2021-09-23)


### Bug Fixes

* add log in to quay registry ([#271](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/271)) ([16080de](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/16080de6a68c551698be9be6dbabd441f55befb0))

### [0.2.3](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/compare/v0.2.2...v0.2.3) (2021-09-23)


### Bug Fixes

* update readme to trigger release ([#269](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/269)) ([19129a9](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/19129a91fae5a068deb55d5243fc1c47953d5d3c))

### [0.2.2](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/compare/v0.2.1...v0.2.2) (2021-09-22)


### Bug Fixes

* rmv path for buildah ([#265](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/265)) ([2341a61](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/2341a61623d4a905c8ace15363e57db8ada173dd))

### [0.2.1](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/compare/v0.2.0...v0.2.1) (2021-09-22)


### Bug Fixes

* container version tag ([#262](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/262)) ([d4c1ef6](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/d4c1ef6b69439b92932b8398bf1cc8c753f16003))

## [0.2.0](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/compare/v0.1.8...v0.2.0) (2021-09-22)


### Features

* adding new rule update_sample to workflow ([#254](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/254)) ([3878c1b](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/3878c1b0089396e79dac614c09bf3985d74de96b))


### Bug Fixes

* maximize build space for container image ([#261](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/261)) ([0de2cc9](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/0de2cc92c75bfa4f69ca48b576a57bd688f539b1))

### [0.1.8](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/compare/v0.1.7...v0.1.8) (2021-09-20)


### Bug Fixes

* add missing path to the Dockerfile job ([#258](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/258)) ([e733d2d](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/e733d2dd1081e632ce39b71cb47d122225011b6d))

### [0.1.7](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/compare/v0.1.6...v0.1.7) (2021-09-20)


### Bug Fixes

* update snakemake actions for container file ([#256](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/256)) ([cb31e92](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/cb31e92d263dfcdc94675aa3ef8a9274b472654a))

### [0.1.6](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/compare/v0.1.5...v0.1.6) (2021-09-16)


### Bug Fixes

* change path of docker file ([#251](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/251)) ([1abebcf](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/1abebcff23ef6c4eb82a414a9a9ceadd84cc0c4d))

### [0.1.5](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/compare/v0.1.4...v0.1.5) (2021-09-15)


### Bug Fixes

* add GISAID var to env ([#248](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/248)) ([e859aed](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/e859aedea76e37594c6a1070827dbc59c3a69b83))

### [0.1.4](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/compare/v0.1.3...v0.1.4) (2021-09-14)


### Bug Fixes

* change " to ' ([#246](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/246)) ([ffca497](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/ffca4975410e8e1e6de96f058c907e19bc5ed5d5))

### [0.1.3](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/compare/v0.1.2...v0.1.3) (2021-09-09)


### Bug Fixes

* add extract gisaid env ([#235](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/235)) ([2b94752](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/2b94752704a669d0a29d05eab23bb9e8d7d11fc5))
* improve if statement with release check ([#239](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/239)) ([12cc85f](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/12cc85f672c71361da48b617869582207c5d3f3e))

### [0.1.2](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/compare/v0.1.1...v0.1.2) (2021-09-06)


### Bug Fixes

* merge push to quay.io into release please ([#231](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/231)) ([e9d782d](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/e9d782dc5db6bd24d097d95f6f945cb02a1ff3aa))
* remove pre von relase action ([#232](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/232)) ([301043f](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/301043f7e1b5a913f3b216eaf66640ae79756f67))

### [0.1.1](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/compare/v0.1.0...v0.1.1) (2021-09-01)


### Bug Fixes

* change trigger of registry release action ([#223](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/223)) ([1464ece](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/1464ece23a689df6f5c9ef0db3a1252b53612cfc))

## 0.1.0 (2021-08-31)


### Bug Fixes

* change release-please-action ([#217](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/217)) ([20af1db](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/20af1dba16d69802a5ed48d453f3a7dc024c26e1))
* change trigger of release please ([#212](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/212)) ([c7a9978](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/c7a9978c8d4439ae77042703b58daa93b416a8a7))
* relase plase indent ([#216](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/216)) ([9140a29](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/9140a2916a34e616c39de4c052567c2dbc51bd3d))
* release command ([#219](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/219)) ([fb84404](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/fb84404bad162ebdc939d8a67ed379ea86d77b75))
* release please command ([#218](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/218)) ([7c64689](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/7c646897d2ff69289b85f24a11bb641628e78c86))
* release please if statement ([#220](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/220)) ([41f41d5](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/41f41d5f21a1f3b1864ee2ad6a1abc8e15a50593))
* release please local PR checkout ([#221](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/221)) ([b348aa7](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/b348aa7ea1eebf00621ee62c52aca655fa8f4c83))
* release please pr tag ([#215](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/215)) ([5d54bb4](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/5d54bb4435d6ac8cdaf696c2b5b991a6ceb49c11))
* release please rmv double dollar ([#222](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/222)) ([0003da9](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/0003da90e8bf65b34ace990576d4e27f5494330c))
* release please step id ([#214](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/214)) ([fa5a9cc](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/fa5a9cccf6930058d169ff2e4a8cbab30bde0ad7))


### Miscellaneous Chores

* release 0.1.0 ([#201](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/issues/201)) ([f211058](https://www.github.com/koesterlab/snakemake-workflow-sars-cov2/commit/f211058ffe0aa8c58b2d35bfb84838ec031b1283))
