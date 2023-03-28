import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(SweaterApp());

class SweaterApp extends StatefulWidget {
  @override
  _SweaterAppState createState() => _SweaterAppState();
}

class _SweaterAppState extends State<SweaterApp> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    TipsPage(),
    CommunityPage(),
    MentorPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sweater',
      theme: ThemeData(
        primaryColor: Color(0xFFF1F2EC),
        backgroundColor: Color(0xFFF1F2EC),
      ),
      home: Scaffold(
        backgroundColor: Color(0xFFF1F2EC),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Color(0xFFF1F2EC),
          actions: [
            IconButton(
              icon: Icon(Icons.account_circle_rounded),
              color: Color(0xFF205072),
              onPressed: () {
                // TODO: 프로필 화면으로 이동
              },
            ),
          ],
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              backgroundColor: Color(0xFF205072),
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: Color(0xFF205072),
              icon: Icon(Icons.lightbulb),
              label: 'Tips',
            ),
            BottomNavigationBarItem(
              backgroundColor: Color(0xFF205072),
              icon: Icon(Icons.group),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              backgroundColor: Color(0xFF205072),
              icon: Icon(Icons.chat),
              label: 'Mentor',
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<dynamic>> fetchPosts(int category) async {
    final response = await http
        .get(Uri.parse('http://127.0.0.1:6060/post?category=$category'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset('assets/images/sweater_logo.png'),
              SizedBox(height: 16.0),
              Text(
                'May I help you?',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Type your question.',
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        //Text('Category1'),
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: fetchPosts(1),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    var post = snapshot.data![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: SizedBox(
                          width: 100,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AspectRatio(
                                aspectRatio: 4 / 3,
                                child: Image.network(
                                  'https://picsum.photos/seed/${index + 1}/200',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(post['title']),
                                    SizedBox(height: 8),
                                    Text(post['nickname']),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
        SizedBox(height: 16.0),
        //Text('Category2'),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal, // 가로 스크롤
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: SizedBox(
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image.network(
                            'https://picsum.photos/seed/${index + 11}/200',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tip${index + 11}'),
                              SizedBox(height: 8),
                              Text('지원금'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TipsPage extends StatefulWidget {
  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  int _selectedTabIndex = 0;

  final List<Widget> _tabsContent = <Widget>[
    TipsTabContent('건강보험료'),
    TipsTabContent('지원금'),
    TipsTabContent('자취방 계약'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              suffixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTabItem('건강보험료', 0),
              buildTabItem('지원금', 1),
              buildTabItem('자취방 계약', 2),
            ],
          ),
        ),
        Expanded(
          child: _tabsContent[_selectedTabIndex],
        ),
      ],
    );
  }

  Widget buildTabItem(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: _selectedTabIndex == index
              ? Color(0xFF205072)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: _selectedTabIndex == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class TipsTabContent extends StatelessWidget {
  final String category;

  TipsTabContent(this.category);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: 10,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: Column(
            children: [
              Expanded(
                child: Image.network(
                  'https://picsum.photos/seed/${category.hashCode + index}/200',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Tip ${index + 1}'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  int _selectedTabIndex = 0;

  final List<Widget> _tabsContent = <Widget>[
    CommunityTabContent('질문게시판'),
    CommunityTabContent('자유게시판'),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buildTabItem('질문게시판', 0),
                  buildTabItem('자유게시판', 1),
                ],
              ),
            ),
            Expanded(
              child: _tabsContent[_selectedTabIndex],
            ),
          ],
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: FloatingActionButton(
            backgroundColor: Color(0xFF205072),
            onPressed: () {
              // TODO: 게시글 작성 또는 검색 기능 구현
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreatePostPage()),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  Widget buildTabItem(String text, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: _selectedTabIndex == index
              ? Color(0xFF205072)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: _selectedTabIndex == index ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}

class CommunityTabContent extends StatelessWidget {
  final String category;

  CommunityTabContent(this.category);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://picsum.photos/seed/${category.hashCode + index}/200',
                ),
              ),
              Text('User ${index + 1}',
                  style:
                      TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
            ],
          ),
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('제목 ${index + 1}',
                style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold)),
            Text(
              '내용 미리보기...',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(fontSize: 12.0),
            ),
          ]),
          onTap: () {
            // TODO: 게시글 화면으로 이동
          },
        );
      },
    );
  }
}

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  String? _selectedCategory;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final List<String> _categories = ['자유게시판', '질문게시판'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시물 작성'),
        backgroundColor: Color(0xFF205072),
      ),
      body: Container(
        color: Color(0xFFF1F2EC),
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: '카테고리 선택',
              ),
              value: _selectedCategory,
              items: _categories.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '제목',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _contentController,
              maxLines: 8,
              decoration: InputDecoration(
                labelText: '내용',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            // 다른 입력 필드 및 위젯 추가
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF205072),
        onPressed: () async {
          // 게시물 작성 로직 구현
          Navigator.pop(context);
          int categoryId = 1;
          int memberId = 1;
          await createPost(_titleController.text, _contentController.text,
              categoryId, memberId);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}

class MentorPage extends StatefulWidget {
  @override
  _MentorPageState createState() => _MentorPageState();
}

class _MentorPageState extends State<MentorPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          labelColor: Color(0xFF205072),
          unselectedLabelColor: Colors.black,
          indicatorColor: Color(0xFF205072),
          tabs: [
            Tab(text: '팔로우 신청목록'),
            Tab(text: '멘토 채팅'),
          ],
        ),
        body: TabBarView(
          children: [
            FollowRequestList(),
            MentorChatList(),
          ],
        ),
      ),
    );
  }
}

class FollowRequestList extends StatefulWidget {
  @override
  _FollowRequestListState createState() => _FollowRequestListState();
}

class _FollowRequestListState extends State<FollowRequestList> {
  List<UserRequest> _requests = List.generate(
    10,
    (index) => UserRequest(
      name: 'User${index + 1}',
      email: 'user${index + 1}@gmail.com',
      approved: false,
    ),
  );

  void _approveMentor(int index) {
    setState(() {
      _requests[index].approved = !_requests[index].approved;
    });
  }

  void _removeRequest(int index) {
    setState(() {
      _requests.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _requests.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
                NetworkImage('https://picsum.photos/seed/${index + 1}/200'),
          ),
          title: Text(_requests[index].name),
          subtitle: Text(_requests[index].email),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: () => _approveMentor(index),
                child:
                    Text(_requests[index].approved ? '멘토 승인 완료' : '멘토 승인 요청 중'),
                style: OutlinedButton.styleFrom(
                  primary: _requests[index].approved
                      ? Color(0xFF205072)
                      : Colors.black,
                  side: BorderSide(
                      color: _requests[index].approved
                          ? Color(0xFF205072)
                          : Colors.black),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () => _removeRequest(index),
              ),
            ],
          ),
        );
      },
    );
  }
}

class UserRequest {
  final String name;
  final String email;
  bool approved;

  UserRequest(
      {required this.name, required this.email, required this.approved});
}

class ChatPreview {
  final String mentiName;
  final String lastMessage;

  ChatPreview({required this.mentiName, required this.lastMessage});
}

class MentorChatList extends StatelessWidget {
  final List<ChatPreview> chatPreviews = List.generate(
    10,
    (index) => ChatPreview(
      mentiName: 'Menti ${index + 1}',
      lastMessage: 'Last message from Menti ${index + 1}',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatPreviews.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage:
                NetworkImage('https://picsum.photos/seed/${index + 1}/200'),
          ),
          title: Text(chatPreviews[index].mentiName),
          subtitle: Text(chatPreviews[index].lastMessage),
        );
      },
    );
  }
}

Future<void> createPost(
    String title, String content, int categoryId, int memberId) async {
  final String apiUrl = 'http://127.0.0.1:6060/post';
  final Uri uri = Uri.parse(apiUrl).replace(
    queryParameters: {
      'memberId': memberId.toString(),
    },
  );
  print(uri);
  final response = await http.post(
    uri,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'title': title,
      'content': content,
      'categoryId': categoryId,
    }),
  );

  if (response.statusCode == 200) {
    print('Post created successfully');
  } else {
    print('Failed to create post');
    print(response.statusCode);
  }
}
