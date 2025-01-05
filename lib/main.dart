import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/job_status.dart';
import 'screens/msg.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");  // .env 파일을 로드합니다.

  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';  // 환경 변수에서 값 가져오기
  final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  if (supabaseUrl.isEmpty || supabaseKey.isEmpty) {
    print('Error: Supabase URL or Key is missing');
    return;
  }

  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseKey,
    );
    print('Supabase initialized successfully!');
  } catch (e) {
    print('Error initializing Supabase: $e');
    return;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',  // Define the initial route
      routes: {
        '/': (context) => HomeShowMsg(),  // Home page
        '/jobstate': (context) => JobStatusPage(),  // Inquiry List page route
      },
    );
  }
}

class HomeShowMsg extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: InquiryListPage(), // InquiryListPage 컴포넌트를 포함
          ),
          SizedBox(height: 20), // JobStatusPage와 버튼 사이의 간격
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/jobstate'); // '/jobstate'를 '/inquiry'로 수정
            },
            child: Text('Go to Inquiry List'),
          ),
          SizedBox(height: 20), // 버튼 하단 간격 추가
        ],
      ),
    );
  }
}
