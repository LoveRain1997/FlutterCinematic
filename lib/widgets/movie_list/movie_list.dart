import 'package:flutter/material.dart';
import 'package:movies_flutter/model/mediaitem.dart';
import 'package:movies_flutter/util/mediaproviders.dart';
import 'package:movies_flutter/util/utils.dart';
import 'package:movies_flutter/widgets/movie_list/movie_list_item.dart';

class MediaList extends StatefulWidget {
  MediaList(this.provider, this.category, {Key key}) : super(key: key);

  final MediaProvider provider;
  final String category;

  @override
  _MediaListState createState() => new _MediaListState();
}

class _MediaListState extends State<MediaList> {
  List<MediaItem> _movies = new List();
  int _pageNumber = 1;
  LoadingState _loadingState = LoadingState.LOADING;
  bool _isLoading = false;

  _loadNextPage() async {



    _isLoading = true;

    try {
      var nextMovies =
          await widget.provider.loadMedia(widget.category, page: _pageNumber);
      if(mounted){
        setState(() {
          _loadingState = LoadingState.DONE;
          _movies.addAll(nextMovies);
          _isLoading = false;
          _pageNumber++;
        });
      }
 ;
    } catch (e) {

      _isLoading = false;
      if (_loadingState == LoadingState.LOADING) {
        if(mounted) {
          setState(() => _loadingState = LoadingState.ERROR);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    return new Center(child: _getContentSection());
  }

  Widget _getContentSection() {
    switch (_loadingState) {
      case LoadingState.DONE:
        return new ListView.builder(
            itemCount: _movies.length,
            itemBuilder: (BuildContext context, int index) {
              if (!_isLoading && index > (_movies.length * 0.7)) {
                _loadNextPage();
              }

              return new MovieListItem(_movies[index]);
            });
      case LoadingState.ERROR:
        return new Text('Sorry, there was an error loading your movie');
      case LoadingState.LOADING:
        return new CircularProgressIndicator();
      default:
        return new Container();
    }
  }
}
