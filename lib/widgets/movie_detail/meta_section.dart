import 'package:flutter/material.dart';
import 'package:movies_flutter/util/utils.dart';


class MetaSection extends StatelessWidget {
  final dynamic data;

  MetaSection(this.data);

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Text("About", style: new TextStyle(color: Colors.white),),
        new Container(height: 8.0,),
        _getMetaInfoSection('Original Title', data['original_title']),
        _getMetaInfoSection('Status', data['status']),
        _getMetaInfoSection('Runtime', formatRuntime(data['runtime'])),
        _getMetaInfoSection('Premiere', formatDate(data['release_date'])),
        _getMetaInfoSection('Budget', formatNumberToDollars(data['budget'])),
        _getMetaInfoSection('Revenue', formatNumberToDollars(data['revenue'])),
        data['homepage'] != null
            ? _getMetaInfoSection('Homepage', data['homepage'], isLink: true)
            : new Container(),
        data['imdb_id'] != null
            ? _getMetaInfoSection(
            'Imdb', getImdbUrl(data['imdb_id']), isLink: true)
            : new Container()
      ],
    );
  }

  Widget _getMetaInfoSection(String title, String content,
      {bool isLink: false}) {
    if (content == null) return null;

    var contentSection = new Expanded(
      flex: 4,
      child: new GestureDetector(
        onTap: () => isLink ? launchUrl(content) : null,
        child: new Text(content,
          style: new TextStyle(
              color: isLink ? Colors.blue : Colors.white, fontSize: 11.0),),
      ),
    );

    return new Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
              flex: 2,
              child: new Text('$title:',
                style: new TextStyle(color: Colors.grey, fontSize: 11.0),),
            ),
            contentSection
          ],
        )
    );
  }
}