import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_itelective/admin/students.dart';
import 'package:flutter_itelective/pages/course_list.dart';
import 'package:flutter_itelective/pages/enrolled_courses.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int totalUsers = 0;
  int totalCourses = 0;
  int totalEnrollments = 0; // New variable for total enrollments
  List<int> userGrowthData = []; // Placeholder for user growth data (for graph)
  List<int> courseGrowthData =
      []; // Placeholder for course growth data (for graph)

  @override
  void initState() {
    super.initState();
    fetchAnalyticsData();
  }

  // Fetch actual data from Firebase Firestore
  Future<void> fetchAnalyticsData() async {
    var usersData = await FirebaseFirestore.instance.collection('users').get();
    var coursesData =
        await FirebaseFirestore.instance.collection('courses').get();
    var enrollmentsData =
        await FirebaseFirestore.instance.collection("enrollments").get();

    // // Fetch historical data for the graphs (just an example)
    // var userGrowthSnapshot =
    //     await FirebaseFirestore.instance.collection('user_growth').get();
    // var courseGrowthSnapshot =
    //     await FirebaseFirestore.instance.collection('course_growth').get();

    try {
      setState(() {
        totalUsers = usersData.docs.length;
        totalCourses = coursesData.docs.length;
        totalEnrollments = enrollmentsData.docs.length; // Set total enrollments

        // // Map the growth data into lists for the graphs
        // userGrowthData =
        //     userGrowthSnapshot.docs.map((doc) => doc['count'] as int).toList();
        // courseGrowthData =
        //     courseGrowthSnapshot.docs.map((doc) => doc['count'] as int).toList();
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchAnalyticsData,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Cards for total users, courses, and enrollments
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                children: [
                  _buildStatCard(
                    'Users',
                    totalUsers,
                    Icons.people,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StudentLists()),
                      );
                    },
                  ),
                  _buildStatCard(
                    'Courses',
                    totalCourses,
                    Icons.book,
                    () {
                    },
                  ),
                  _buildStatCard(
                    'Enrolled Students',
                    totalEnrollments,
                    Icons.school,
                    () {
                      
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),

              // Bar Graph for User Growth
              _buildBarChart(userGrowthData, 'User Growth'),

              SizedBox(height: 16),

              // Line Graph for Course Growth
              _buildLineChart(courseGrowthData, 'Course Growth'),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a statistics card with an icon, number, and text
  Widget _buildStatCard(
      String title, int count, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 50,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 10),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Bar chart for user growth
  Widget _buildBarChart(List<int> data, String title) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            data.isNotEmpty
                ? BarChart(
                    BarChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: true),
                      borderData: FlBorderData(show: false),
                      barGroups: data
                          .asMap()
                          .map<int, BarChartGroupData>((index, value) {
                            return MapEntry(
                              index,
                              BarChartGroupData(
                                x: index,
                                barRods: [], // Adjust barRod data as needed
                              ),
                            );
                          })
                          .values
                          .toList(),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }

  // Line chart for course growth
  Widget _buildLineChart(List<int> data, String title) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            data.isNotEmpty
                ? LineChart(
                    LineChartData(
                      gridData: FlGridData(show: false),
                      titlesData: FlTitlesData(show: true),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: data
                              .asMap()
                              .entries
                              .map(
                                (e) => FlSpot(
                                    e.key.toDouble(), e.value.toDouble()),
                              )
                              .toList(),
                          isCurved: true,
                          barWidth: 3,
                          belowBarData: BarAreaData(show: false),
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
