// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables , prefer_final_fields

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/models.dart';
import '../constants.dart';

class PlayingSongScreen extends StatefulWidget {
  @override
  State<PlayingSongScreen> createState() => _PlayingSongScreenState();
}

class _PlayingSongScreenState extends State<PlayingSongScreen> {
  late AudioPlayer audioPlayer;
  late AudioCache audioCache;
   Duration position = new Duration();
   Duration musicLength = new Duration();

  int songElapsedTime = 0; // Should be changed while playinh music
  bool playingSong = false;

  Song song1 = Song(
      id: '1',
      title: 'One Kiss',
      artist: 'Dua Lipa',
      songPath: 'One Kiss Dua Lipa.mp3',
      imagePath: 'assets/images/one kiss.png');

  Song song = Song(
      id: '2',
      title: 'UnStoppable',
      artist: 'Sia',
      songPath: 'sia unstoppable.mp3',
      imagePath: 'assets/images/sia-unstoppable.jpg');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    // Load the song into the cache then
    // get Song Music Length Duration

    // To Handle Progress Time Changing
    audioPlayer.onAudioPositionChanged.listen(
      (Duration duration) {
        setState(() {
          position = duration;
        });
      },
    );
  }

  String timeStringFormat(int time)
  {
    String result='';
      int minutes = time ~/ 60;
      if(minutes <10)
        result = '0'+minutes.toString();
      else
        result = minutes.toString();
      result +=':';
      int seconds = time.remainder(60);
      if(seconds <10)
        result += '0'+seconds.toString();
      else
        result += seconds.toString();
      return result;

  }

  void seektoSec(int value) async
  {
    await audioPlayer.seek(new Duration(seconds: value));
  }

  void playSong() async {
    await audioCache.play(song.songPath);
    print('Playing ${song.artist} : ${song.title}');

    // set the Length of the Music Song
    int timeInMilliseconds = await audioPlayer.getDuration();
    musicLength = new Duration(milliseconds: timeInMilliseconds);

  }

  void pauseSong() async {
    await audioPlayer.pause();

    print('Pausing ${song.title}');
    print(audioPlayer.state);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    print('All are rebuilt again');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: _buildAppBar(),
        body: Container(
          padding: EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              Expanded(flex: 4, child: _buildImageContainer()),
              SizedBox(
                height: kDefaultPadding,
              ),
              Expanded(flex: 3, child: _buildDetailsContainer()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultBorderRaduis),
        //color: Colors.yellow,
        image: DecorationImage(
          image: AssetImage(
            song.imagePath!,
          ),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildDetailsContainer() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${song.title}',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite,
                  color: kSecondaryColor,
                  size: 30,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '${song.artist}',
              style: TextStyle(
                color: kGrayColor,
                fontSize: 20,
              ),
            ),
          ),
          _buildSlider(),
          _buildButtonsContainer(),
        ],
      ),
    );
  }

  Widget _buildSlider() {
    return Container(
      child: Column(
        children: [
          Slider.adaptive(

            value: position.inSeconds.toDouble(),
            max: musicLength.inSeconds.toDouble(),
            onChanged: (value) {

              seektoSec(value.toInt());
              //print(value);
            },
            activeColor: kSecondaryColor,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${timeStringFormat(position.inSeconds)}'),
              Text('${timeStringFormat(musicLength.inSeconds)}'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildButtonsContainer() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.shuffle,
                size: 26,
                color: kGrayColor,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.keyboard_double_arrow_left_sharp,
                size: 26,
                color: Colors.white,
              )),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(15),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: kSecondaryColor),
            child: IconButton(
                onPressed: () {
                  if (playingSong) {
                    // We were playing song so now we need to pause it.
                    pauseSong();
                  } else {
                    // We were pausing song so now we need to play it.
                    playSong();
                  }

                  setState(() {
                    playingSong = !playingSong;
                  });
                },
                icon: Icon(
                  playingSong ? Icons.pause : Icons.play_arrow,
                  size: 30,
                  color: Colors.black,
                )),
          ),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.keyboard_double_arrow_right_sharp,
                size: 26,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.sync,
                size: 26,
                color: kGrayColor,
              )),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: kGrayColor,
          size: 32,
        ),
        onPressed: () {},
      ),
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Playing now ',
            style: TextStyle(color: kGrayColor),
          ),
          Icon(
            Icons.volume_up,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.queue_music_sharp,
              color: kGrayColor,
              size: 32,
            ))
      ],
    );
  }
}
