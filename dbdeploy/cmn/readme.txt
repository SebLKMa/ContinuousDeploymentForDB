1. Read and understand what build.xml is doing.

2. To drop existing and create first baseline db schema, run from command line:

ant clean


3. Subsequently, all changes should be added as individual .sql scripts in folder ./cmn_v1_0, then run from command line:

ant apply-cmn_v1_0

(changelog table is updated automatically)


4. After a stable release, you can create ./cmn_v1_1 etc for each subsequent patches and releases.

