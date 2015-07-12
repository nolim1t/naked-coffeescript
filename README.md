**What**
------------
This is a bare bones coffeescript+express powered server (foreman/heroku ready) to save you time.

**UPDATE** - As of July 2015, this file is Docker ready!

**Why**
------------
Society (particularly in tech moves really fast). Nowadays it seems a LOT of people have ideas, and there is a lack of time to do them and launch quick.

So I've decided to copy one of my past projects which was *roughly structured* in this format and create a template for people to use (pull requests welcome!).

So you can build, launch, or fail (not in that order) faster so you can move on to the next best thing. Unless of course the coffeescript fad passes haha

**How**
------------
> 1. Clone this project
> 2. Do a ``` git archive --format=tar --prefix=AppName/ HEAD | (cd /App/BasePath && tar xf -)```
> 3. Do a ``` git init``` and create a new repo for your project
> 4. Do a ```git add .``` and add all the stuff to the new project
> 5. ``` rmdir lib/mongo ; rmdir lib/randomstring ; rmdir lib/apicommon```
> 6.  ``` git submodule add git://github.com/nolim1t/apicommon.git lib/apicommon ; git submodule add git://github.com/nolim1t/node-mongo-with-heroku.git lib/mongo ; git submodule add git://github.com/nolim1t/randomstring lib/randomstring```
> 7. Make changes and break stuff
> 8. The below is optional if you wish to use docker. Replace mydb with your database name, myid with a docker username, and myapp with your app name.
> 8. ``` docker run -p 127.0.0.1:27017 --name mydb -v /data:/data/db -d mongo:2.2```
> 9. ``` docker build -t myid/myapp .```
> 10. ``` docker run -e MONGOCONTAINER=mydb --link=mydb:mongodb -p 127.0.0.1:5000:3000  -it --name myapp -d=true myid/myapp```

**Quick fix (6/6/13) **
------------
Fpr some reason the latest (as of this writing) version is not working. Delete all your node modules, then do a npm update with the package JSON file (from this repo) and it should work. Other than that I have no idea why it broke all of a sudden.

**Example app**
------------
> Just to prove that this is running, there is an example app at http://naked-coffeescript.herokuapp.com/

**Suggestions**
------------
If there are any issues, I do expect to see a pull request sent or issue logged, or everythings perfect (which it isn't)
