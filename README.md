# Analysis of ICE datasets via Deportation Data Project

This repository performs exploratory analysis of immigration enforcement data obtained via FOIA by the [Deportation Data Project](https://deportationdata.org/). Results of scripts and notebooks in this repository should be considered preliminary and interpreted with caution.

This analysis follows that performed on data obtained by UWCHR and analyzed in https://github.com/uwchr/ice-enforce and https://github.com/UWCHR/ice-detain; for more information see associated notebooks at https://uwchr.github.io/ice-enforce/ and https://uwchr.github.io/ice-detain/.

## Repository description

### Data

Large files are excluded from this repository. Data for this repository can be downloaded via https://deportationdata.org/data.html; and via the associated UWCHR repositories linked above.

To execute tasks in this repository, first download the data files linked above and ensure they are stored in the indicated directory within the Git respository: original datasets are stored in `import/input/` (we recommend renaming these files to replace space characters with underscores).

### Repository structure

This project uses "Principled Data Processing" techniques and tools developed by [@HRDAG](https://github.com/HRDAG); see for example ["The Task Is A Quantum of Workflow."](https://hrdag.org/2016/06/14/the-task-is-a-quantum-of-workflow/)

The repository is divided into separate tasks which follow a regular structure; tasks are linked using symlinks and scripts are executed via Makefiles.

- `import/` - Contains original Deportation Data Project Excel files in `import/input/`
- `detain-unique-stays/` - Generates additional placement and stay-level analysis fields in detentions data
- `detain-headcount/` - Calculates daily detention headcount by given characteristic
- `analyze/` - Contains various analysis and prototyping notebooks

##  To-do

- [ ] Document repository setup and task flow in code (e.g., rename import datasets, create downstream symlinks and folders not included in Git repo, etc.)
- [ ] Set up tasks for publishing descriptive analysis notebooks.
