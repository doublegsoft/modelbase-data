<#import '/$/modelbase.ftl' as modelbase>

<#macro print_imports_of_list_view obj indent>
${''?left_pad(indent)}import 'package:flutter/material.dart';
</#macro>

<#macro print_members_of_list_view obj indent>
///!
/// the ${dart.nameType(obj.name)} objects.
///
${''?left_pad(indent)}static List<dynamic> _${dart.nameVariable(modelbase.get_object_plural(obj))} = [];
</#macro>

<#macro print_methods_of_list_view obj indent>
${''?left_pad(indent)}///!
${''?left_pad(indent)}/// builds the list view for ${dart.nameType(obj.name)} objects.
${''?left_pad(indent)}///
${''?left_pad(indent)}Widget _buildListView(BuildContext context) {
${''?left_pad(indent)}  return FutureBuilder<List<dynamic>>(
${''?left_pad(indent)}    future: _fetch${dart.nameType(obj.plural)}(),
${''?left_pad(indent)}    builder: (context, snapshot) {
${''?left_pad(indent)}      if (snapshot.hasData) {
${''?left_pad(indent)}        List<dynamic>? data = snapshot.data;
${''?left_pad(indent)}        if (data == null || data.isEmpty) {
${''?left_pad(indent)}          // refresh button
${''?left_pad(indent)}          return _buildRefresh();
${''?left_pad(indent)}        }
${''?left_pad(indent)}        return RefreshIndicator(
${''?left_pad(indent)}          child: ListView.builder(
${''?left_pad(indent)}            itemCount: _${dart.nameVariable(obj.plural)}.length,
${''?left_pad(indent)}            itemBuilder: (context, index) {
${''?left_pad(indent)}              return _build${dart.nameType(obj.name)}(_${dart.nameVariable(obj.plural)}[index]);
${''?left_pad(indent)}            }
${''?left_pad(indent)}          ),
${''?left_pad(indent)}          onRefresh: () async {
${''?left_pad(indent)}            // refresh ${dart.nameType(obj.name)} list view
${''?left_pad(indent)}            while (_${dart.nameVariable(obj.plural)}.length > 0) {
${''?left_pad(indent)}              _${dart.nameVariable(obj.plural)}.removeAt(0);
${''?left_pad(indent)}            }
${''?left_pad(indent)}            setState(() {
${''?left_pad(indent)}              _fetch${dart.nameType(obj.plural)}();
${''?left_pad(indent)}            });
${''?left_pad(indent)}          },
${''?left_pad(indent)}        );
${''?left_pad(indent)}      } else if (snapshot.hasError) {
${''?left_pad(indent)}        return _buildRefresh();
${''?left_pad(indent)}      }
${''?left_pad(indent)}      return CircularProgressIndicator();
${''?left_pad(indent)}    },
${''?left_pad(indent)}  );
${''?left_pad(indent)}}

${''?left_pad(indent)}///!
${''?left_pad(indent)}/// Builds list tile.
${''?left_pad(indent)}///
${''?left_pad(indent)}_build${dart.nameType(obj.name)}(dynamic ${dart.nameVariable(obj.name)}) {
${''?left_pad(indent)}  return new Column(
${''?left_pad(indent)}    children: [Slidable(
${''?left_pad(indent)}      actionPane: SlidableDrawerActionPane(),
${''?left_pad(indent)}      secondaryActions: <Widget>[
${''?left_pad(indent)}        IconSlideAction(
${''?left_pad(indent)}          color: Colors.lightBlue,
${''?left_pad(indent)}          icon: Icons.call,
${''?left_pad(indent)}          foregroundColor: Colors.white,
${''?left_pad(indent)}          onTap: () {
${''?left_pad(indent)}            _goto({
${''?left_pad(indent)}              "${dart.nameVariable(obj.name)}Id": ${dart.nameVariable(obj.name)}["${dart.nameVariable(obj.name)}Id"],
${''?left_pad(indent)}            });
${''?left_pad(indent)}          },
${''?left_pad(indent)}        ),
${''?left_pad(indent)}      ],
${''?left_pad(indent)}      child: ListTile(
${''?left_pad(indent)}        leading: CircleAvatar(
${''?left_pad(indent)}          radius: 18,
${''?left_pad(indent)}          child: Stack(
${''?left_pad(indent)}            children: [
${''?left_pad(indent)}              ClipOval(
${''?left_pad(indent)}                child: Image.asset("asset/img/avatar.png", width: 36, height: 36, fit: BoxFit.fill)
 ${''?left_pad(indent)}             ),
${''?left_pad(indent)}              Badge(
${''?left_pad(indent)}                position: BadgePosition.topEnd(top: 0, end: 0),
${''?left_pad(indent)}                badgeContent: null,
${''?left_pad(indent)}                child: Container(),
${''?left_pad(indent)}              ),
${''?left_pad(indent)}            ],
${''?left_pad(indent)}          ),
${''?left_pad(indent)}        ),
${''?left_pad(indent)}        onTap: () {
${''?left_pad(indent)}          _goto({
${''?left_pad(indent)}            "${dart.nameVariable(obj.name)}Id": ${dart.nameVariable(obj.name)}["${dart.nameVariable(obj.name)}Id"],
${''?left_pad(indent)}          });
${''?left_pad(indent)}        },
${''?left_pad(indent)}        title: Text(${dart.nameVariable(obj.name)}["${dart.nameVariable(obj.name)}Name"],
${''?left_pad(indent)}          style: TextStyle(
${''?left_pad(indent)}            fontSize: 18.0,
${''?left_pad(indent)}            fontWeight: FontWeight.w600,
${''?left_pad(indent)}          ),
${''?left_pad(indent)}        ),
${''?left_pad(indent)}        subtitle: Text(user["description"]),
${''?left_pad(indent)}      ),
${''?left_pad(indent)}    ),
${''?left_pad(indent)}    Divider(
${''?left_pad(indent)}      color: Colors.grey,
${''?left_pad(indent)}      height: 1.0
${''?left_pad(indent)}    )]
${''?left_pad(indent)}  );
${''?left_pad(indent)}}
${''?left_pad(indent)}
${''?left_pad(indent)}///!
${''?left_pad(indent)}/// fetches ${dart.nameType(obj.name)} objects from remote server
${''?left_pad(indent)}///
${''?left_pad(indent)}Future<List> _fetch${dart.nameType(obj.plural)}() async {
${''?left_pad(indent)}  AppbaseHttpClientResponse resp = await AppbaseHttpClient.getUsers();
${''?left_pad(indent)}  while (_${dart.nameVariable(obj.plural)}.length > 0) {
${''?left_pad(indent)}    _${dart.nameVariable(obj.plural)}.removeAt(0);
${''?left_pad(indent)}  }
${''?left_pad(indent)}  if (resp.hasError) {
${''?left_pad(indent)}    return [];
${''?left_pad(indent)}  }
${''?left_pad(indent)}  resp.getDataAsList().forEach((${dart.nameVariable(obj.name)}) {
${''?left_pad(indent)}    _${dart.nameVariable(obj.plural)}.add(${dart.nameVariable(obj.name)});
${''?left_pad(indent)}  });
${''?left_pad(indent)}
${''?left_pad(indent)}  setState(() {});
${''?left_pad(indent)}  return _${dart.nameVariable(obj.plural)};
${''?left_pad(indent)}}
${''?left_pad(indent)}
${''?left_pad(indent)}///!
${''?left_pad(indent)}/// navigates to call
${''?left_pad(indent)}///
${''?left_pad(indent)}Future<void> _goto(Map params) async {
${''?left_pad(indent)}  await Navigator.pushNamed(context, '/where',
${''?left_pad(indent)}    arguments: params
${''?left_pad(indent)}  );
${''?left_pad(indent)}}
${''?left_pad(indent)}
${''?left_pad(indent)}///!
${''?left_pad(indent)}/// the refresh button when empty list or error occured.
${''?left_pad(indent)}///
${''?left_pad(indent)}Widget _buildRefresh() {
${''?left_pad(indent)}  return Center(
${''?left_pad(indent)}    child: TextButton(
${''?left_pad(indent)}      child: Icon(Icons.refresh,
${''?left_pad(indent)}        size: 36,
${''?left_pad(indent)}      ),
${''?left_pad(indent)}      onPressed: () => setState((){}),
${''?left_pad(indent)}    )
${''?left_pad(indent)}  );
${''?left_pad(indent)}}
</#macro>