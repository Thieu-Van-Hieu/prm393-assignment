import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_fschool_frontend/model/response/user_workspace_response.dart';
import 'package:my_fschool_frontend/notifier/user_profile_notifier.dart';

final selectedWorkspaceIndexProvider = StateProvider<int>((ref) => 0);

final activeWorkspaceProvider = Provider<UserWorkspaceResponse?>((ref) {
  final index = ref.watch(selectedWorkspaceIndexProvider);
  final userProfileAsync = ref.watch(userProfileProvider);

  return userProfileAsync.maybeWhen(
    data: (userResponse) {
      if (userResponse == null) return null;
      final workspaces = userResponse.userWorkspaceResponses;

      // Cơ chế phòng vệ chống sập app (Index Out of Bounds)
      if (workspaces.isEmpty) return null;
      final safeIndex = index >= workspaces.length ? 0 : index;

      return workspaces[safeIndex];
    },
    orElse: () => null,
  );
});
