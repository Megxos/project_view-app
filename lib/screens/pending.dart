import 'package:flutter/material.dart';
import 'package:project_view/services/project_item.dart';

class Pending extends StatefulWidget {
  @override
  _PendingState createState() => _PendingState();
}

class _PendingState extends State<Pending> {
  List <ProjectItem> rows = [
    ProjectItem(item: "Cement", price: 23000, quantity: 2, selected: false),
    ProjectItem(item: "Window", price: 50000, quantity: 10, selected: false),
  ];

  final _formkey = GlobalKey<FormState>();
  final itemController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();

  @override
  List <ProjectItem> selectedItems;
  void initState(){
    selectedItems = [];
    super.initState();
  }
  //function to add new item
  void addItem(){
    setState(() {
      rows.insert(0, ProjectItem(
          item: itemController.text,
          price: int.parse(priceController.text),
          quantity: int.parse(quantityController.text),
          selected: false
      ));
    });
  }

  bool _isSnackbarActive = false;
  bool _showCheckboxColumn  = false;
  Widget build(BuildContext context) {
    int itemCount = rows.length;
    List <bool> selected = List<bool>.generate(itemCount, (index) => false);
    // function to unselect items
    void unselectItem(){
      for(int i = 0; i < selectedItems.length; i++){
        print(selectedItems[i]);
        setState(() {
          rows[rows.indexOf(selectedItems[i])].selected = false;
          selectedItems.remove(selectedItems[i]);
        });
      }
    }

    // function to manage selected items
    final actionSnackBar = SnackBar(
      elevation: 0,
      duration: Duration(days: 1),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text("Select Action")
            ],
          ),
          Row(
            children: [
              FlatButton.icon(
                  onPressed: (){},
                  icon: Icon(Icons.delete),
                  label: Text("Delete selected")
              )
            ],
          ),
          Row(
            children: [
              FlatButton.icon(
                  onPressed: (){
                    Scaffold.of(context).hideCurrentSnackBar();
                  },
                  icon: Icon(Icons.done),
                  label: Text("Mark as complete")
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FlatButton.icon(
                  onPressed: (){
                    Scaffold.of(context).hideCurrentSnackBar();
                  },
                  icon: Icon(Icons.close),
                  label: Text("Close")
              )
            ],
          ),
        ],
      ),
    );

    // function to select table item
    void selectItem(value, index, ProjectItem item){
      setState(() {
        rows[index].selected = value;
        _showCheckboxColumn ? null : _showCheckboxColumn = true;
      });
      if(value && !_isSnackbarActive){
        setState(() {
          selectedItems.add(item);
          _isSnackbarActive = true;
        });
        Scaffold.of(context).showSnackBar(actionSnackBar);
      }
      else if(value && _isSnackbarActive){
        setState(() {
          selectedItems.add(item);
        });
      }
      else if(!value && selectedItems.length > 1){
        setState(() {
          selectedItems.remove(item);
        });
      }
      else if(!value && selectedItems.length <= 1){
        Scaffold.of(context).hideCurrentSnackBar();
        setState(() {
          selectedItems.remove(item);
          _isSnackbarActive = false;
          _showCheckboxColumn = false;
        });
      }
    }

    // dialog to add new item
    final itemDialog = AlertDialog(
      scrollable: true,
      title: Text("Add New Item"),
      actions: [
        IconButton(icon: Icon(Icons.close, color: Colors.red, size: 40,),onPressed: (){Navigator.pop(context);},),
        IconButton(
          icon: Icon(Icons.done, color: Colors.green, size: 40,),
          onPressed: (){
            if(_formkey.currentState.validate()){
              addItem();
              Navigator.pop(context);
            }
          },
        ),
      ],
      content: Form(
        key: _formkey,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: itemController,
                validator: (value)=> value.length < 3 ? "min of 3 characters" : null,
                maxLength: 25,
                decoration: InputDecoration(
                    hintText: "Cement",
                    labelText: "Item"
                ),
              ),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                validator: (value){
                  if(value.length < 1 ){
                    return "field is required";
                  }else if(int.parse(value) < 1){
                    return "cannot be 0";
                  }else{
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: "Price",
                    hintText: "5,000"
                ),
              ),
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                validator: (value){
                  if(value.length < 1 ){
                    return "field is required";
                  }else if(int.parse(value) < 1){
                    return "cannot be 0";
                  }else{
                    return null;
                  }
                },
                decoration: InputDecoration(
                    hintText: "3",
                  labelText: "Quantity"
                ),
              ),
            ]
        ),
      ),
    );

    // dialog to show donation account details
    final donateDialog = AlertDialog(
      title: Text("Account details"),
      content: Stack(
        overflow: Overflow.visible,
        children: [
          Positioned(
            top: -120,
            right: 75,
            child: InkResponse(
              child: FlatButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  child: Icon(Icons.close),
                ),
              )
            ),
          ),
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Bank: GTB"),
            Text("Account No: 0463040482"),
            Text("Account Name: Micah Iliya")
          ],
        ),
        ]
      ),
    );
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 2.0,),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.676,
            width: double.infinity,
            child: SingleChildScrollView(
              child: DataTable(
                showCheckboxColumn: _showCheckboxColumn,
                columns: [
                  DataColumn(label: Text("Item", textAlign: TextAlign.center, textScaleFactor: 1.3, style: TextStyle(fontWeight: FontWeight.bold),),),
                  DataColumn(label: Text("Price", textAlign:TextAlign.center, textScaleFactor: 1.3,style: TextStyle(fontWeight: FontWeight.bold)),),
                  DataColumn(label: Text("Quantity", textAlign:TextAlign.center, textScaleFactor: 1.3,style: TextStyle(fontWeight: FontWeight.bold)),),
                ],
                rows: List<DataRow>.generate(itemCount, (index) => DataRow(
                    selected: rows[index].selected,
                    onSelectChanged: (bool value){
                      selectItem(value, index, rows[index]);
                    },
                    cells: [
                      DataCell(Text(rows[index].item),),
                      DataCell(Text("${rows[index].price}")),
                      DataCell(Text("${rows[index].quantity}"),showEditIcon: true,onTap: (){})
                    ]
                ))
              )
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ButtonTheme(
                  child: FlatButton(
                    onPressed: (){
                      showDialog(context: context, builder: (context)=> donateDialog);
                    },
                    child: Text("Make A Donation", style: TextStyle(color: Colors.white),),
                    color: Colors.indigo[500],
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  buttonColor: Colors.indigo[500],
                ),
              ),
              SizedBox(width: 4,),
              Expanded(
                child: Row(
                  children: [
                    Expanded(child: OutlineButton(
                      onPressed: (){
                        showDialog(context: context, builder: (context)=> itemDialog);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                      ),
                      child: Text("Add New Item", style: TextStyle(color: Colors.indigo[500])),
                      borderSide: BorderSide(color: Colors.indigo[500], width: 3,),
                    )
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
