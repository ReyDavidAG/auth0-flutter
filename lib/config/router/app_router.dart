import 'package:go_router/go_router.dart';
import 'package:auth0_app/presentation/screens/screens.dart';

final appRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    name: HomeScreen.routeName,
    builder: (context, state) => HomeScreen(),
  )
]);
