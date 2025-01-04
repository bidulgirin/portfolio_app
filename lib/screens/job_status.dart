import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JobStatusPage extends StatefulWidget {
  @override
  _JobStatusPageState createState() => _JobStatusPageState();
}

class _JobStatusPageState extends State<JobStatusPage> {
  final SupabaseClient _supabase = Supabase.instance.client;

  Stream<String> _streamJobStatus() async* {
    while (true) {
      final response = await _supabase
          .from('job_status')
          .select('job_status')
          .eq('id', 1)
          .single();
      if (response != null && response['job_status'] != null) {
        yield response['job_status'];
      } else {
        yield 'Error';
      }
      await Future.delayed(Duration(seconds: 1)); // 1초마다 갱신
    }
  }

  Future<void> _updateJobStatus(String status) async {
    try {
      final response = await _supabase
          .from('job_status')
          .update({'job_status': status})
          .eq('id', 1);

      if (response != null && response.error == null) {
        setState(() {});
        print('상태 업데이트 성공: ${response.data}');
      } else {
        if (response?.error != null) {
          print('상태 업데이트 실패: ${response?.error?.message}');

        } else {
          print('응답이 null입니다. 상태 업데이트에 실패했습니다.');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('상태 업데이트에 실패했습니다.')),
          );
        }
      }
    } catch (e) {
      print('상태 업데이트 중 오류 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('상태 업데이트 중 오류가 발생했습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('구직 상태 업데이트'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<String>(
          stream: _streamJobStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              String _jobStatus = snapshot.data!;

              return Column(
                children: [
                  Text(
                    '현재 상태: $_jobStatus',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  RadioListTile<String>(
                    title: Text('구직중'),
                    value: '구직중',
                    groupValue: _jobStatus,
                    onChanged: (value) {
                      if (value != null) {
                        _updateJobStatus(value);
                      }
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('구직완료'),
                    value: '구직완료',
                    groupValue: _jobStatus,
                    onChanged: (value) {
                      if (value != null) {
                        _updateJobStatus(value);
                      }
                    },
                  ),
                ],
              );
            } else {
              return Center(child: Text('데이터가 없습니다.'));
            }
          },
        ),
      ),
    );
  }
}
