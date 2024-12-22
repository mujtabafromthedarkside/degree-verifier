import 'package:flutter/material.dart';
import 'package:degree_verifier/Config/constants.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  onTapFunction(BuildContext context, String pageRoute) {
    // find current route
    String currentRoute = ModalRoute.of(context)!.settings.name!;

    // close drawer
    Navigator.pop(context);
    if (currentRoute == pageRoute) return;

    // pop current page and push the new one. /DegreeVerifier is the base page
    if (currentRoute != "/DegreeVerifier") Navigator.pop(context);
    if (pageRoute != "/DegreeVerifier") Navigator.pushNamed(context, pageRoute);
  }

  Widget SideBarItem(BuildContext context, String text, String pageRoute, IconData icon) {
    return ListTile(
        // leading: Icon(
        //   icon,
        //   color: NormalTextColor,
        // ),
        title: Text(
          text,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal, fontSize: 20),
        ),
        onTap: () {
          onTapFunction(context, pageRoute);
        });
  }

  Widget sidebarDivider() {
    return const Divider(color: Colors.grey, thickness: 1);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    Size screenSize = MediaQuery.of(context).size;
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
      ),
      backgroundColor: designColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(margin: EdgeInsets.fromLTRB(10, 0, 0, 0), child: Text("Degree Verification System", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20))),
                sidebarDivider(),
                SideBarItem(context, "Verify Degree", "/DegreeVerifier", Icons.people_alt),
                SideBarItem(context, "Add Degree", "/AddDegree", Icons.price_change),
              ],
            ),
          ),
          sidebarDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 10), child: Text("Presented by: Mujtaba & Abdullah", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal))),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
