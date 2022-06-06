class Song{
  String id;
  String title;
  String artist;
  String songPath;
  String? imagePath = 'assets/images/song.jpg';

  Song({required this.id , required this.title , required this.artist , required this.songPath , this.imagePath});
}