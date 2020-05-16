import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Category {
  final Widget icon;
  final String label;

  Category(this.icon, this.label);
}

class CategoriesList extends StatelessWidget {
  const CategoriesList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Category> categories = [
      Category(Icon(FontAwesomeIcons.award), "All"),
      Category(Icon(FontAwesomeIcons.utensils), "Food & Beverage"),
      Category(Icon(FontAwesomeIcons.tag), "Limited Edition"),
      Category(Icon(FontAwesomeIcons.tools), "Services"),
      Category(Icon(FontAwesomeIcons.shoppingBag), "Shopping"),
      Category(Icon(FontAwesomeIcons.luggageCart), "Travel"),
      Category(Icon(FontAwesomeIcons.ticketAlt), "Entertainment"),
    ];
    return Container(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          Category category = categories[index];
          return Container(
            width: 72,
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).dividerColor.withOpacity(0.05),
                  ),
                  height: 60,
                  width: 60,
                  child: IconTheme(
                    data: Theme.of(context)
                        .iconTheme
                        .copyWith(color: Theme.of(context).primaryColor),
                    child: category.icon,
                  ),
                ),
                SizedBox(height: 4,),
                Text(
                  category.label,
                  style: Theme.of(context).textTheme.caption,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
        itemCount: categories.length,
      ),
    );
  }
}
