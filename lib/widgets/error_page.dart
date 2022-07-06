import 'package:flutter/material.dart';

Route<dynamic> errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: const [
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Icon(
                      Icons.delete_forever,
                      size: 48,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(strokeWidth: 4, value: 1.0
                        // valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.withOpacity(0.5)),
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Page Not Found'),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Press back button on your phone',
              style: TextStyle(color: Color(0xff39399d), fontSize: 28),
            ),
            const SizedBox(
              height: 20,
            ),
            /*ElevatedButton(
                    onPressed: () {
                      Navigator.pop();
                      return;
                    },
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Colors.orange),
                    ),
                    child: const Text('Back to home'),
                  ),*/
          ],
        ),
      ),
    );
  });
}
