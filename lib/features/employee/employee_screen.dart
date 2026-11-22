/// Employee page (deck use case: "Employee tracks locations, delivers
/// marketplace items, and collects bin waste").
library;

import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/models.dart';
import '../../core/theme.dart';

class EmployeeScreen extends StatelessWidget {
  const EmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final tasks = state.employeeTasks;
    return Scaffold(
      appBar: AppBar(title: const Text('My route')),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks assigned.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final task in tasks)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: GCard(
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: GColors.mint,
                            child: Icon(
                              task.kind == TaskKind.binCollection
                                  ? Icons.delete_outline
                                  : Icons.local_shipping_outlined,
                              color: GColors.seed,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(task.title,
                                    style: const TextStyle(
                                        fontWeight:
                                            FontWeight.w700)),
                                Text(task.area,
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54)),
                              ],
                            ),
                          ),
                          switch (task.status) {
                            TaskStatus.assigned => FilledButton.tonal(
                                onPressed: () => AppScope.read(context)
                                    .advanceTask(task.id),
                                child: const Text('Start'),
                              ),
                            TaskStatus.enRoute => FilledButton(
                                onPressed: () => AppScope.read(context)
                                    .advanceTask(task.id),
                                child: const Text('Complete'),
                              ),
                            TaskStatus.done => const Icon(
                                Icons.check_circle,
                                color: GColors.leaf),
                          },
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
