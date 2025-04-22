import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getDesireMoviesByCityandSchedule(String movieStatus, String cityName) async {
    final response = await _client
      .from('movie')
      .select('''
        m_title, 
        m_genre,
        m_imageurl,
        m_duration,
        m_desc,
        schedule (
          sch_status,
          studio (
            cinema (
              city (
                city_id,
                c_name
              )
            )
          )
        )
      ''')
      .eq('m_status', movieStatus)
      .eq('schedule.studio.cinema.city.c_name', cityName)
      .execute();

    if (response.status == 200) {
      return List<Map<String, dynamic>>.from(response.data as List);
    } else {
      throw Exception('Error fetching movies: ${response.status} - ${response.data}');
    }
  }

  // Future<List<Map<String, dynamic>>> getMovieswithDetails(String movieStatus) async {
  //   final response = await _client
  //     .from('movie')
  //     .select('''

  //     ''')
  // }

  Future<String> downloadAndCacheImage(String url, String title) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$title.jpg'; // Save with movie title

    File file = File(filePath);
    if (await file.exists()) {
      return filePath; // Use cached image
    }

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      throw Exception('Failed to download image');
    }
  }


  Future<List<Map<String, dynamic>>> getListofLocation() async {
    final response = await _client
      .from('city')
      .select('c_name')
      .execute();

    if (response.status == 200) {
      return List<Map<String, dynamic>>.from(response.data as List);
    } else {
      throw Exception('Error fetching location: ${response.status} - ${response.data}');
    }
  }

}
