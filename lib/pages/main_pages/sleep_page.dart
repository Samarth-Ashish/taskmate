import 'package:flutter/material.dart';
import 'package:taskmate/views/texts.dart';

class SleepPage extends StatefulWidget {
  const SleepPage({super.key});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 120, 194, 255),
                        Color.fromARGB(255, 25, 147, 218),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  child: const Icon(
                    Icons.bedtime,
                    size: 30,
                    color: Colors
                        .white, // This color will be replaced by the gradient
                  ),
                ),
                const SizedBox(width: 8),
                mada('Sleep Schedule'),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              color: Color(0xFF86D0FF),
              // margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              shadowColor: Colors.blue,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        manjari(
                          "Bedtime",
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(height: 8),
                        manjari("10:00 PM", fontSize: 30),
                      ],
                    ),
                    Column(
                      children: [
                        manjari(
                          "Waketime",
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(height: 8),
                        manjari("6:00 AM", fontSize: 30),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Icon(
                  Icons.alarm,
                  size: 30,
                  color: const Color.fromARGB(
                    255,
                    39,
                    167,
                    231,
                  ), // This color will be replaced by the gradient
                ),
                const SizedBox(width: 8),
                mada('Sleep Duration'),
              ],
            ),
            const SizedBox(height: 8),
            // Card(
            //   color: Color(0xFF86D0FF),
            //   elevation: 4,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(16),
            //   ),
            //   child: Container(
            //     padding: EdgeInsets.all(16),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Row(
            //           children: [
            //             Icon(Icons.bedtime, color: Colors.white, size: 24),
            //             SizedBox(width: 8),
            //             Text(
            //               'Sleep Duration',
            //               style: TextStyle(
            //                 fontSize: 18,
            //                 fontWeight: FontWeight.w600,
            //                 color: Colors.white,
            //               ),
            //             ),
            //           ],
            //         ),
            //         SizedBox(height: 16),
            //         Stack(
            //           alignment: Alignment.center,
            //           children: [
            //             // Background circle
            //             Container(
            //               width: 200,
            //               height: 200,
            //               decoration: BoxDecoration(
            //                 shape: BoxShape.circle,
            //                 color: Colors.white.withOpacity(0.2),
            //               ),
            //             ),
            //             // Progress indicator
            //             SizedBox(
            //               width: 180,
            //               height: 180,
            //               child: CircularProgressIndicator(
            //                 value: 0.8, // 80% of sleep goal
            //                 strokeWidth: 12,
            //                 backgroundColor: Colors.white.withOpacity(0.3),
            //                 valueColor: AlwaysStoppedAnimation<Color>(
            //                   Colors.white,
            //                 ),
            //               ),
            //             ),
            //             // Center text
            //             Column(
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 Text(
            //                   '8h 30m',
            //                   style: TextStyle(
            //                     fontSize: 28,
            //                     fontWeight: FontWeight.bold,
            //                     color: Colors.white,
            //                   ),
            //                 ),
            //                 Text(
            //                   'of 10h 30m goal',
            //                   style: TextStyle(
            //                     fontSize: 14,
            //                     color: Colors.white.withOpacity(0.8),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ],
            //         ),
            //         SizedBox(height: 16),
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             _buildSleepInfo('Bedtime', '10:30 PM'),
            //             _buildSleepInfo('Wake up', '7:00 AM'),
            //             _buildSleepInfo('Sleep', '8h 30m'),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            SleepBarCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSleepInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8)),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class SleepBarCard extends StatelessWidget {
  const SleepBarCard({super.key});

  @override
  Widget build(BuildContext context) {
    final sleepHours = [
      5.0,
      6.5,
      4.5,
      7.0,
      6.0,
      8.5,
      4.0,
    ]; // Sunday to Saturday
    final maxHours = 9.0;

    return Container(
      width: 400,
      height: 350,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 154, 216, 255),
            Color.fromARGB(255, 105, 197, 255),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // const Text(
          //   '8 hrs',
          //   style: TextStyle(
          //     fontSize: 18,
          //     fontWeight: FontWeight.w600,
          //     color: Colors.black87,
          //   ),
          // ),
          manjari('8 hrs', fontSize: 26, fontWeight: FontWeight.w700),
          // const SizedBox(height: 8),
          const Divider(color: Color.fromARGB(66, 11, 125, 170)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final barHeight = (sleepHours[index] / maxHours) * 240;
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 20,
                    height: barHeight,
                    decoration: BoxDecoration(
                      // color: Colors.blue[700],
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 2, 158, 255),
                          Color.fromARGB(255, 107, 198, 255),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ['S', 'M', 'T', 'W', 'T', 'F', 'S'][index],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(221, 14, 149, 187),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
