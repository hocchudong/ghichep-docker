# 18. `Pin` phiên bản của images

____
____

# <a name="content">Nội dung</a>

![https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg](https://nickjanetakis.com/assets/blog/cards/docker-tips-and-tricks-56b5452dc709c8861641d9011d55ed5e6f5138b7d1e76a5e258160077c903076.jpg)

- Việc thực hiện ghim các phiên bản tới image chỉ mất vài giât. Nhưng nó sẽ giúp ta tiết kiệm rất nhiều thời gian trong tương lai vì một vài lý do sau đây:

    + Ghim một phiên bản chỉ có nghĩa là bạn đặt một phiên bản cụ thể và có mức độ khác nhau về độ chính xác bạn có thể ghim phiên bản của bạn.

- **Không ghim (No pinning)**:

        # It will use the very latest version at build time.
        FROM node

        # This is almost always the worst option because if you built Node today
        # you would get 8.4.0, and if you did it a few years from now
        # you might get 12.1.4 or whatever happens to be out at the time.
        #
        # This makes things extremely inconsistent, and there's a very high chance
        # a major version change such as going from 1 to 2 will severely break things.


- **Major version pinning:**

        # Grab the latest 8.x.x version at the time of building.
        FROM node:8

        # In my opinion this is also a really bad idea, because sure, you will get
        # locked into version 8 here, but you run the risk of originally creating your
        # image with 8.1 but a few months later, you build 8.9 which has a few
        # backwards incompatible changes or performance regressions.
        #
        # Both major and no pinning is likely going to cause a lot of headaches and
        # wasted time while you try to track down and fix incompatible code.

- **Minor version pinning:**

        # Grab the latest 8.4.x version at the time of building.
        FROM node:8.4

        # This starts to get very reasonable because chances are there won't be many
        # breaking changes from 8.4.0 to 8.4.6. Chances are you'll get critical bug
        # fixes and other safe changes.
        #
        # This is an excellent balance between it being annoying to keep your pinned
        # versions up to date, and receiving important bug fixes. I would do this as my
        # default pin precision.

- **Patch version pinning:**

        # Grab 8.4.0 at the time of building.
        FROM node:8.4.0

        # For version sensitive images this may also be a very good idea. Most popular
        # web application services and languages (nginx, Postgres, Redis, Node, Ruby, etc.)
        # don't need this precision, but hey, you're in charge here.
        #
        # When in doubt, the more precise you are the better but "real world" usage
        # dictates (at least for me), that minor version pinning works great in practice.


____

# <a name="content-others">Các nội dung khác</a>
