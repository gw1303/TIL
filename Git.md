# Git

> git은 분산형 버젼관리 시스템(DVCS)이다.
>
> 소스코드 형상관리 도구로, 코드의 이력을 관리할 수 있다.

## Git 로컬 저장소 활용하기

> git은 `repository(저장소)`로 각각 프로젝트를 관리한다.

### 0. 기본설정

Git에서 이력을 남기기 위해 작성자(author)정보를 추가한다.

매 컴퓨터에서 최초로 한 번만 설정하면 된다.

```bash
$ git config --global user.name 유저네임
$ git config --global user.email 이메일

$ git config --global -l // 유저 정보 확인
```

* 일반적으로 `{유저네임}, {이메일}`에는 깃헙 정보를 넣는다



### 1. 저장소 생성

```bash
student@M13034 MINGW64 ~/Desktop/새 폴더 (2)
$ git init
Initialized empty Git repository in C:/Users/student/Desktop/새 폴더 (2)/.git/

student@M13034 MINGW64 ~/Desktop/새 폴더 (2) (master)


```

### 2.  add

> 커밋 대상 파일을 `staging area`로 이동 시킨다.
>
> 즉, 이력을 남길 파일을 담아 놓는 것이다.

```bash
$ git add .
$ git add git.md
$ git add images/
```

* `.`은 그 디렉토리 내의 모든 파일을 의미한다.

항상 `git status` 명령어를 통해 상태를 확인하자.

```bash
$ git status
On branch master

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        "\354\203\210 \355\205\215\354\212\244\355\212\270 \353\254\270\354\204\234.txt"

nothing added to commit but untracked files present (use "git add" to track)

student@M13034 MINGW64 ~/Desktop/새 폴더 (2) (master)
$ git add .

student@M13034 MINGW64 ~/Desktop/새 폴더 (2) (master)
$ git status
On branch master

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
        new file:   "\354\203\210 \355\205\215\354\212\244\355\212\270 \353\254\270\354\204\234.txt"
```

> git에서 이력을 남기기 위해ㅐ서는 커밋을 진행

```bash
git commit -m 'Git 기초'
```



* 이력을 확인하기 위해서는 `git log`를 활용한다.

```bash
$ git log
commit 56af80e52e5e5bd1434cb2dedeb7d7f653d91bd2 (HEAD -> master)
Author: gw1303 <gw1303@nate.com>
Date:   Thu Dec 5 12:36:31 2019 +0900

    Git 기초
```

## Git 원격 저장소 활용하기

### 0. 기본설정

> 원격 저장소를 생성한다. (예 - github)

### 1. 원격 저장소 등록

> `origin` 이라는 이름으로 해당 url 원격 저장소로 등록

```bash
git remote add origin https://github.com/gw1303/TIL.git 
//뒤의 url을 가진 origin이라는 저장소 연결해줘

$ git remote -v
origin  https://github.com/gw1303/TIL.git (fetch)
origin  https://github.com/gw1303/TIL.git (push)
```

### 2. 원격 저장소 push

> `orgin`이라는 이름을 가진 원격 저장소로 push

```bash
git push -u origin master

Enumerating objects: 6, done.
Counting objects: 100% (6/6), done.
Delta compression using up to 4 threads
Compressing objects: 100% (5/5), done.
Writing objects: 100% (6/6), 8.07 KiB | 4.04 MiB/s, done.
Total 6 (delta 0), reused 0 (delta 0)
To https://github.com/gw1303/TIL.git
 * [new branch]      master -> master
Branch 'master' set up to track remote branch 'master' from 'origin'.
```

* 변경되는 사항이 있으면 항상 `add`, `commit`, `push`를 진행한다.



## 딥러닝

coursera - ML/DL (원록적인 수업느낌) 

udacity - ML (조금 쉽게)

edx

# 모두를 위한 머신러닝/딥러닝 강의