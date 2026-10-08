# Mission Control for Lunabotics BC

## Development
Start your environment by running
```bash
git clone https://github.com/Joey574/lunabotics
```
this downloads all the files you'll need locally, you can then move into that project directory with
```bash
cd ./lunabotics
```

Main is a protected branch, meaning no one can push to it directly, all pushes must be reviewed by another member of the team before going into main
to develop features collaboratively I recommend running
```bash
git checkout -b yourname-dev
```

This gives you your own branch to freely develop on without needed reviews for each push, others will also be able to checkout your branch and contribute to it, when you're ready to commit something to main, you can open up github via the browser and it will prompt you to create a pull request.

The main commands you are going to need for git are the following
```bash
# stages and commits all the uncommited local changes
git add .
git commit -m "some message"

# typically you just run those one after another, and you can combine them into
git commit -am "some message"

# push sends local commits up to github's servers
# pull will bring them back down, including anyone elses commits
git push origin yourname-dev
git pull origin yourname-dev

# you use checkout to switch between branches
git checkout main
git checkout yourname-dev
```

I'd recommend always running ```git pull``` when you start development to make sure you have the most up to date changes
