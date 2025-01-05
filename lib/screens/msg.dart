import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InquiryListPage extends StatefulWidget {
  @override
  _InquiryListPageState createState() => _InquiryListPageState();
}

class _InquiryListPageState extends State<InquiryListPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  Stream<List<Map<String, dynamic>>>? inquiriesStream;

  @override
  void initState() {
    super.initState();
    inquiriesStream = streamInquiries();
  }

  Stream<List<Map<String, dynamic>>> streamInquiries() async* {
    while (true) {
      try {
        final response = await supabase.from('inquiry').select();
        print("response");
        print(response);
        if (response != null && response is List) {
          yield List<Map<String, dynamic>>.from(response);
        } else {
          yield [];
        }
      } catch (e) {
        print('Error streaming inquiries: $e');
        yield [];
      }
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메세지온거'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: inquiriesStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error loading inquiries.'));
          }

          final inquiries = snapshot.data ?? [];

          if (inquiries.isEmpty) {
            return Center(
              child: Text('No inquiries found.'),
            );
          }

          return ListView.builder(
            itemCount: inquiries.length,
            itemBuilder: (context, index) {
              final inquiry = inquiries[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(inquiry['subject'] ?? 'No Subject'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${inquiry['name'] ?? 'N/A'}'),
                      Text('Email: ${inquiry['email'] ?? 'N/A'}'),
                      Text('Phone: ${inquiry['phone'] ?? 'N/A'}'),
                      Text('Message: ${inquiry['message'] ?? 'N/A'}'),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
