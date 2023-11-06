import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:dash/dash.dart';
class HomeTest extends StatefulWidget {
  const HomeTest({super.key});

  @override
  State<HomeTest> createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: InkWell(
          onTap: ()=>  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>   DashVideoPlayer()),
          ),
          child: Container(
            width: 300,
              height: 300,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class DashVideoPlayer extends StatefulWidget {
    String mpdUrl = '';

  DashVideoPlayer( );

  @override
  _DashVideoPlayerState createState() => _DashVideoPlayerState();
}

class _DashVideoPlayerState extends State<DashVideoPlayer> {
  late BetterPlayerController _tokenController;
  late BetterPlayerController _widevineController;
  late BetterPlayerController _fairplayController;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
    BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );
    _widevineController = BetterPlayerController(betterPlayerConfiguration);
    // BetterPlayerDataSource _widevineDataSource = BetterPlayerDataSource(
    //   BetterPlayerDataSourceType.network,
    //   Constants.widevineVideoUrl,
    //   drmConfiguration: BetterPlayerDrmConfiguration(
    //       drmType: BetterPlayerDrmType.widevine,
    //       licenseUrl: Constants.widevineLicenseUrl,
    //       headers: {"Test": "Test2"}),
    // );
    String urls ='https://u6ymkkpex6vod.vcdn.cloud/manifest/m3u8/7fddbaaf350e4439911cb528986f2f21/7fddbaaf350e4439911cb528986f2f21.m3u8';
    final uri1 = Uri.parse(urls);
    final uri2 = uri1.replace(scheme: 'https');
    // _widevineController.setupDataSource(_widevineDataSource);
    _fairplayController = BetterPlayerController(betterPlayerConfiguration);
    BetterPlayerDataSource _fairplayDataSource = BetterPlayerDataSource(

      headers: {'application':'x-mpegURL'},
      BetterPlayerDataSourceType.network,
      urls,
      // uri2.toString(),
      drmConfiguration: BetterPlayerDrmConfiguration(
        drmType: BetterPlayerDrmType.fairplay,
        certificateUrl: "https://fp-keyos.licensekeyserver.com/cert/e52066bef89341db2d1f2f34e7c4c232.der",
        licenseUrl: "https://onlinica.com/api/v1/video-player/license?drm-type=fairplay",
        headers: {'application':'x-www-form-urlencoded'}
      ),
    );
    _fairplayController.setupDataSource(_fairplayDataSource);

    super.initState();
  }

  @override
  void dispose() {
    // _fairplayController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DRM player"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Fairplay - certificate url based EZDRM. Works only for iOS.",
                style: TextStyle(fontSize: 16),
              ),
            ),
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer(controller: _fairplayController),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen( );

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network('https://u6ymkkpex6vod.vcdn.cloud/manifest/m3u8/8091891c518f4adbb969fb64dd7961ba/8091891c518f4adbb969fb64dd7961ba.m3u8')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MPEG-DASH Video Player'),
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : CircularProgressIndicator(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
