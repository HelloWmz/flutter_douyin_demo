import 'package:douyin_demo/pages/RecommendPage/BottomSheet.dart';
import 'package:douyin_demo/providers/RecommendProvider.dart';
import 'package:douyin_demo/widgets/BottomBar.dart';
// import 'package:douyin_demo/widgets/FavAnimation.dart' as prefix0;
import 'package:flutter/material.dart';
// import 'package:marquee/marquee.dart';
import 'package:marquee_flutter/marquee_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'widgets/FavAnimation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "某音",
      theme: ThemeData(primaryColor: Color(0xff121319)),
      home: RecommendPage(selIndex: 0,),
    );
  }
}

class RecommendPage extends StatelessWidget {
  const RecommendPage({Key key,@required this.selIndex}) : super(key: key);
  final int selIndex;
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              builder: (context) => RecommendProvider(),
            )
          ],
          child: Scaffold(
            
            resizeToAvoidBottomInset: false,
            body: Container(
              decoration: BoxDecoration(color: Colors.black),
              child: Stack(children: [
                CenterImage(),
                Home(),
              ]),
            ),
            bottomNavigationBar: BottomSafeBar(selIndex: selIndex,),
          ));
  }
}

class BottomSafeBar extends StatelessWidget {
  const BottomSafeBar({Key key,@required this.selIndex}) : super(key: key);
  final int selIndex;
  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    // double toBottom=MediaQuery.of(context).viewInsets.bottom;
    return Container(
      // padding: EdgeInsets.only(top:toBottom),
      decoration: BoxDecoration(color: Colors.black),
      child: SafeArea(
          child: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(color: Colors.black),
          height: 60,
          // decoration: BoxDecoration(color: Colors.black),
          child: BtmBar(selectIndex: selIndex,),
        ),
      )),
    );
  }
}

class CenterImage extends StatelessWidget {
  const CenterImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double bottom = MediaQuery.of(context).viewInsets.bottom;
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    return Center(
      child: Container(
          // padding: EdgeInsets.only(top: bottom),
          child: Image.asset(provider.mainInfo.videoPath)),
    );
  }
}

class VideoBack extends StatefulWidget {
  VideoBack({Key key}) : super(key: key);

  _VideoBackState createState() => _VideoBackState();
}

class _VideoBackState extends State<VideoBack> {
  VideoPlayerController _controller;
  bool _isPlaying = false;
  String url =
      "https://www.guojio.com/video/07a7faa1-3696-4af7-aeac-2d6cf6bf25f9.mp4";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.network(this.url)
      // 播放状态
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      // 在初始化完成后必须更新界面
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _controller.value.initialized
          // 加载成功
          ? new AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : new Container(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    RecommendProvider provider = Provider.of<RecommendProvider>(context);

    double rpx = screenWidth / 750;
    return Stack(children: [
      Positioned(
        top: 20*rpx,
        // height: 120,
        width: screenWidth,
        child: SafeArea(
            child: Container(
          // decoration: BoxDecoration(color: Colors.pinkAccent),
          child: TopTab(),
        )),
      ),
      Positioned(
        bottom: 0,
        width: 0.70 * screenWidth,
        height: 260 * rpx,
        child: Container(
          // decoration: BoxDecoration(color: Colors.redAccent),
          child: BtnContent(),
        ),
      ),
      Positioned(
        right: 0,
        width: 0.2 * screenWidth,
        height: 500 * rpx,
        top: 0.45 * screenHeight,
        child: Container(
          // decoration: BoxDecoration(color: Colors.orangeAccent),
          child: ButtonList(),
        ),
      ),
      Positioned(
        bottom: 20 * rpx,
        right: 0,
        width: 0.2 * screenWidth,
        height: 0.2 * screenWidth,
        child: Container(
          // decoration: BoxDecoration(color: Colors.purpleAccent),
          child: RotateAlbum(),
        ),
      )
    ]);
  }
}

class TopTab extends StatefulWidget {
  TopTab({Key key}) : super(key: key);

  _TopTabState createState() => _TopTabState();
}

class _TopTabState extends State<TopTab> with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(vsync: this, length: 2, initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // BottomNavigationBar(items: [BottomNavigationBarItem(icon: null,)],)
        SizedBox(
          width: 17 * rpx,
        ),
        Icon(
          Icons.search,
          size: 50 * rpx,
          color: Colors.white,
        ),
        Container(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 90 * rpx),
                width: 500 * rpx,
                child: TabBar(
                  indicatorColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  indicatorPadding: EdgeInsets.symmetric(horizontal: 30),
                  unselectedLabelStyle:
                      TextStyle(color: Colors.grey[700], fontSize: 18),
                  controller: _controller,
                  tabs: <Widget>[Text("关注"), Text("推荐")],
                  
                  
                ))),
        Icon(
          Icons.live_tv,
          size: 30,
          color: Colors.white,
        ),
        SizedBox(
          width: 10,
        ),
      ],
    );
  }
}



class BtnContent extends StatelessWidget {
  const BtnContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text(
              "@${provider.mainInfo.userName}",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            subtitle: Text(
              "${provider.mainInfo.content}",
              style: TextStyle(color: Colors.white, fontSize: 16),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.music_note,
                color: Colors.white,
              ),
              // Marquee(text: "",),

              // Container(
              //     width: 200,
              //     height: 20,
              //     child: MarqueeWidget(
              //       text: '${provider.mainInfo.desc}',
              //       textStyle: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           color: Colors.white,
              //           fontSize: 16),
              //       // scrollAxis: Axis.horizontal,
              //       // crossAxisAlignment: CrossAxisAlignment.start,
              //       // blankSpace: 20.0,
              //       // velocity: 100.0,
              //       // pauseAfterRound: Duration(seconds: 1),
              //       // startPadding: 10.0,
              //       // accelerationDuration: Duration(seconds: 1),
              //       // accelerationCurve: Curves.linear,
              //       // decelerationDuration: Duration(milliseconds: 500),
              //       // decelerationCurve: Curves.easeOut,
              //     ))
            ],
          )
        ],
      ),
    );
  }
}

class RotateAlbum extends StatefulWidget {
  RotateAlbum({Key key}) : super(key: key);

  _RotateAlbumState createState() => _RotateAlbumState();
}

class _RotateAlbumState extends State<RotateAlbum>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  var animation;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));
    animation = RotationTransition(
      turns: Tween(begin: 0.0, end: 1.0).animate(_controller)
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            // _controller.forward(from: 0.0);
          }
        }),
      child: Container(
          child: CircleAvatar(
        backgroundImage: NetworkImage(
            "https://gss1.bdstatic.com/9vo3dSag_xI4khGkpoWK1HF6hhy/baike/s%3D500/sign=dde475320ee9390152028d3e4bec54f9/d009b3de9c82d1586d8294a38f0a19d8bc3e42a4.jpg"),
      )),
    );
    _controller.forward(from: 0.0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      child: animation,
    );
  }
}

class ButtonList extends StatefulWidget {
  ButtonList({Key key}) : super(key: key);

  _ButtonListState createState() => _ButtonListState();
}

class _ButtonListState extends State<ButtonList> {
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    RecommendProvider provider = Provider.of<RecommendProvider>(context);
    List<IconAnimationStage> stages1 = List<IconAnimationStage>();
    stages1.add(IconAnimationStage(
        color: Colors.grey[100],
        start: 1.0,
        end: 0.0,
        duration: Duration(milliseconds: 200)));
    stages1.add(IconAnimationStage(
        color: Colors.redAccent,
        start: 0.0,
        end: 1.3,
        duration: Duration(milliseconds: 300)));
    stages1.add(IconAnimationStage(
        color: Colors.redAccent,
        start: 1.3,
        end: 1.0,
        duration: Duration(milliseconds: 100)));

    List<IconAnimationStage> stages2 = List<IconAnimationStage>();
    stages2.add(IconAnimationStage(
        color: Colors.grey[100],
        start: 1.0,
        end: 1.2,
        duration: Duration(milliseconds: 200)));
    stages2.add(IconAnimationStage(
        color: Colors.grey[100],
        start: 1.2,
        end: 1.0,
        duration: Duration(milliseconds: 200)));

    List<IconAnimationStage> stages3 = List<IconAnimationStage>();
    stages3.add(IconAnimationStage(
        color: Colors.redAccent,
        start: 1.0,
        end: 1.2,
        duration: Duration(milliseconds: 200)));
    stages3.add(IconAnimationStage(
        color: Colors.grey[100],
        start: 1.2,
        end: 1.0,
        duration: Duration(milliseconds: 200)));
    double iconSize = 70 * rpx;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              width: 90 * rpx,
              height: 105 * rpx,
              child: Stack(
                children: <Widget>[
                  Container(
                    // decoration: BoxDecoration(c),
                      width: 90 * rpx,
                      height: 90 * rpx,
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage("${provider.mainInfo.avatarUrl}"),
                      )),
                  Positioned(
                    bottom: 0,
                    left: 25 * rpx,
                    child: Container(
                      width: 40 * rpx,
                      height: 40 * rpx,
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(25)),
                      child: Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )),
          IconText(
            text: "${provider.mainInfo.favCount}",
            icon: !provider.mainInfo.ifFaved
                ? AnimatedIconWidget(
                    key: UniqueKey(),
                    animationList: stages1,
                    icon: Icons.favorite,
                    size: iconSize,
                    provider: provider,
                    callback: () {
                      provider.tapFav();
                    })
                : AnimatedIconWidget(
                    key: UniqueKey(),
                    animationList: stages3,
                    icon: Icons.favorite,
                    size: iconSize,
                    provider: provider,
                    callback: () {
                      provider.tapFav();
                    },
                  ),
          ),
          IconText(
            text: "${provider.mainInfo.replyCount}",
            icon: AnimatedIconWidget(
              animationList: stages2,
              icon: Icons.comment,
              size: iconSize,
              callbackDelay: Duration(milliseconds: 200),
              callback: () {
                showBottom(context, provider);
              },
            ),
          ),
          IconText(
            text: "${provider.mainInfo.shareCount}",
            icon: AnimatedIconWidget(
              animationList: stages2,
              icon: Icons.reply,
              size: iconSize,
            ),
          ),
        ],
      ),
    );
  }
}

// class ButtonList extends StatelessWidget {
//   const ButtonList({Key key}) : super(key: key);

//   @override

// }

// getButtonList(double rpx, RecommendProvider provider, BuildContext context) {

//   return
// }

class IconText extends StatelessWidget {
  const IconText({Key key, this.icon, this.text}) : super(key: key);
  final AnimatedIconWidget icon;
  final String text;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          icon,
          Container(
              // alignment: Alignment.center,
              child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 25 * rpx),
          )),
        ],
      ),
    );
  }
}

showBottom(context, provider) {
  // RecommendProvider provider = Provider.of<RecommendProvider>(context);
  double height = MediaQuery.of(context).size.height;
  provider.setScreenHeight(height);
  provider.hideBottomBar();
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(10)),
      context: context,
      builder: (_) {
        return Container(
            height: 600,
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: ReplyFullList(pCtx:context)));
      });
}
