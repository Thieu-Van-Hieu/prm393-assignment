import 'package:flutter/material.dart';
import 'package:my_fschool_frontend/constant/app_colors.dart';
import 'package:my_fschool_frontend/model/response/user_response.dart';

class ChildListSheetContent extends StatelessWidget {
  final UserResponse userResponse;
  final int initialSelectedIndex;
  final ValueChanged<int> onChildSelected;

  const ChildListSheetContent({
    super.key,
    required this.userResponse,
    required this.initialSelectedIndex,
    required this.onChildSelected,
  });

  @override
  Widget build(BuildContext context) {
    final selectedChildIndex = ValueNotifier<int>(initialSelectedIndex);
    final students = userResponse.parentStudents ?? [];

    return SafeArea(
      child: ValueListenableBuilder<int>(
        valueListenable: selectedChildIndex,
        builder: (context, currentIndex, childWidget) {
          if (students.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(child: Text('Không tìm thấy thông tin học sinh')),
            );
          }

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.55,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final child = students[index];
                final isSelected = index == currentIndex;
                final hasValidUrl =
                    child.avatarUrl != null &&
                    child.avatarUrl!.trim().isNotEmpty;

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 6.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.orangeFPT.withValues(alpha: 0.5)
                          : Colors.grey.withValues(alpha: 0.15),
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.divider,
                      ),
                      child: ClipOval(
                        child: hasValidUrl
                            ? Image.network(
                                child.avatarUrl!,
                                fit: BoxFit.cover,
                                headers: const {
                                  'User-Agent':
                                      'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36',
                                },
                                frameBuilder:
                                    (
                                      context,
                                      frameChild,
                                      frame,
                                      wasSynchronouslyLoaded,
                                    ) {
                                      if (wasSynchronouslyLoaded) {
                                        return frameChild;
                                      }
                                      return frame != null
                                          ? AnimatedOpacity(
                                              opacity: 1.0,
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              child: frameChild,
                                            )
                                          : const Icon(
                                              Icons.person,
                                              color: AppColors.textSecondary,
                                            );
                                    },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.person,
                                    color: AppColors.textSecondary,
                                  );
                                },
                              )
                            : const Icon(
                                Icons.person,
                                color: AppColors.textSecondary,
                              ),
                      ),
                    ),
                    title: Text(
                      child.fullName,
                      style: TextStyle(
                        fontFamily: 'Asap',
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.orangeFPT
                            : AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      child.currentClass?.className ?? 'Chưa xếp lớp',
                      style: const TextStyle(
                        fontFamily: 'Asap',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: AppColors.orangeFPT,
                            size: 22,
                          )
                        : const Icon(
                            Icons.circle_outlined,
                            color: Colors.grey,
                            size: 20,
                          ),
                    onTap: () {
                      selectedChildIndex.value = index;
                      onChildSelected(index);
                      Navigator.of(context).pop();
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
