import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/job_status.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load();  // .env 파일을 로드합니다.

  final supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';  // 환경 변수에서 값 가져오기
  final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: JobStatusPage(),
    );
  }
}
