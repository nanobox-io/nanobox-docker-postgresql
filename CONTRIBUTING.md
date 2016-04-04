# Nanobox Contribution Guidelines

Thanks for your interest in helping on this Nanobox project. We try to keep the contribution process fairly simple, but we do have some guidelines to follow:

## Contribution Process

#### 1. Fork, then clone the Project
This project can be forked on Github. Once forked, clone the project to your local machine.

```bash
git clone git@github.com:your-username/project-name.git
```

#### 2. Create your feature branch
The branch name should be descriptive of and specific to the feature you're working on.

```bash
git checkout -b my-new-feature
```

#### 3. Commit your changes
*When contirbuting, all changes should be submitted in a single commit. If you have multiple commits, squash merge them into a single commit. You can find a great squash merge tutorial [here](https://ariejan.net/2011/07/05/git-squash-your-latests-commits-into-one/).*

```bash
git commit -am 'Added some feature'
```

#### 4. Push to the feature branch

```bash
git push origin my-new-feature
```

#### 5. Create new pull request
Once pushed, [create a new pull request](https://help.github.com/articles/using-pull-requests/).

## Contribution Guidelines
Pull requests must do the following in order to be merged.

1. Match the style of code already existing in the project.
2. Must not contain any merge conflicts *(Pull and merge master before submitting the pull request)*.
3. Include tests for the modifications in your commit.

## Docker Image Build
Upon receiving the pull request, we will review the update(s) and merge them into master once approved. Once merged into master, a new Docker image will automatically be generated.
