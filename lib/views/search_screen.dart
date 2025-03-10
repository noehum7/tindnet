import 'package:flutter/material.dart';
import 'package:tindnet/views/search_results_screen.dart';
import 'package:tindnet/widgets/custom_toast.dart';
import '../constants/app_colors.dart';
import '../models/category.dart';
import '../widgets/custom_drawer_customer.dart';

/*
/// `SearchScreen` es una clase que proporciona una interfaz para que los usuarios busquen empresas por categoría o nombre.
///
/// Los usuarios pueden buscar empresas de dos maneras:
/// 1. Pueden seleccionar una categoría de una lista de categorías predefinidas. Al seleccionar una categoría, se les redirige a la pantalla `SearchResultsScreen` que muestra todas las empresas de esa categoría.
/// 2. Pueden introducir el nombre de una empresa en un campo de texto. Al pulsar el botón de búsqueda, se les redirige a la pantalla `SearchResultsScreen` que muestra todas las empresas con ese nombre.
///
/// Esta clase utiliza varios métodos auxiliares:
/// - `build`: Construye la interfaz de usuario de la pantalla de búsqueda. Contiene un `GridView` con las categorías y un campo de texto para la búsqueda por nombre.
///
/// El método `build` de esta clase devuelve un `Scaffold` que contiene un `AppBar` y un `SingleChildScrollView`. El `SingleChildScrollView` contiene un `Column` que a su vez contiene el `GridView` y el campo de texto.
 */

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String selectedCategory = '';
  String companyName = '';
  CustomToast customToast = CustomToast();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TindNet"),
        toolbarHeight: MediaQuery.of(context).size.height * 0.07,
      ),
      drawer: CustomDrawerCustomer(currentPage: 'Búsqueda'),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width * 0.9,
          child: SingleChildScrollView(
            // Añade esto
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    '¿Qué servicio buscas?',
                    style: TextStyle(
                        fontSize: 22,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.0),
                Text('Buscar por categorías',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 30.0),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true, // Añado esta línea para evitar errores de renderizado: GridView se dimensionará a sí mismo para que su altura sea la misma que la altura total de los elementos que contiene.
                  children: List.generate(categories.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = categories[index].name;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SearchResultsScreen(
                              selectedCategory: selectedCategory,
                              companyName: '',
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8.0),
                            // Espacio alrededor del icono
                            decoration: BoxDecoration(
                              color: Colors.white, // Fondo blanco
                              borderRadius: BorderRadius.circular(
                                  10.0),
                            ),
                            child: Icon(categories[index].icon),
                          ),
                          SizedBox(height: 10.0),
                          // Text(services[index].name),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(categories[index].name),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                SizedBox(height: 25.0),
                Text('Buscar por empresa',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.welcomeColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: <Widget>[
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            companyName = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Nombre',
                          contentPadding: EdgeInsets.only(right: 40.0, left: 20.0),
                        ),
                      ),
                      Positioned(
                        right: 10.0,
                        child: Icon(
                          Icons.search,
                          color: AppColors.primaryColor,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  child: Text('Buscar',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  onPressed: () {
                    if (!companyName.isNotEmpty) {
                      customToast.showErrorToast(
                          "El campo de búsqueda no puede estar vacío.");
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchResultsScreen(
                            selectedCategory: '',
                            companyName: companyName.trim(),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
