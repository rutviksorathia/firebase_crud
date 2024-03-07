import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crud/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (model) {
        model.fetchData();
      },
      builder: (context, model, child) {
        return Scaffold(
          body: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                controller: model.nameController,
              ),
              ElevatedButton(
                onPressed: () {
                  model.addData();
                },
                child: const Text('Add'),
              ),
              ElevatedButton(
                onPressed: () => model.updateData(),
                child: const Text('Update'),
              ),
              StreamBuilder(
                stream: model.getData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return GestureDetector(
                            onTap: () => model.clickName(
                                  ds['name'],
                                  ds.id,
                                ),
                            child: Text(ds['name']));
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
