part of '../../home.dart';

Widget _buildDrawerHeader() {
  return const UserAccountsDrawerHeader(
    accountName: Text('User Name'),
    accountEmail: Text('user.name@email.com'),
    currentAccountPicture: CircleAvatar(
      backgroundColor: Colors.white,
      child: FlutterLogo(size: 42.0),
    ),
  );
}

void _signOutCurrentUser(BuildContext context) {
  context.read<SignInBloc>().add(const SignInLogoutRequested());
  Navigator.of(context)
      .pushAndRemoveUntil<void>(LoginPage.route(), (route) => false);
}

Widget _getDrawer(BuildContext context) {
  return Drawer(
      child: Column(
    children: <Widget>[
      _buildDrawerHeader(),
      Builder(
        builder: (context) {
          final userId =
              context.select((SignInBloc bloc) => bloc.state.email.value);
          return Text('UserID: $userId');
        },
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text('Device 1'),
        onTap: () => Navigator.pop(context),
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: const Text('Device 2'),
        onTap: () => Navigator.pop(context),
      ),
      ListTile(
        leading: const Icon(Icons.add),
        title: Text(S.of(context)!.addDevice),
        onTap: () => Navigator.pop(context),
      ),
      ListTile(
        leading: const Icon(Icons.settings),
        title: Text(S.of(context)!.settings),
        onTap: () => Navigator.pop(context),
      ),
      const Spacer(),
      const Divider(thickness: 1.5),
      ListTile(
        leading: const Icon(Icons.power_settings_new, color: Colors.red),
        title: Text(S.of(context)!.signOut),
        onTap: () => _signOutCurrentUser(context),
      ),
    ],
  ));
}
