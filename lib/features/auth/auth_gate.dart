/*

AUTH GATE - THIS will countinously check if user is logged in or not

------------------------------------------------------------------------------------

unauthenticated -> go to login page
authenticated -> go to home page

*/

import 'package:fintrack/features/auth/presentation/login_page.dart';
import 'package:fintrack/features/home/presentation/home_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // Listen to auth state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,

      // Build appropriate page based on auth state
      builder: (context, snapshot) {
        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // check if there is a valid session currently
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
