package prm393.se1911.assignment.myfschoolbackend.model.response;

import lombok.Builder;

@Builder
public record UserWorkspaceResponse(
        String classId,
        String className,
        String schoolYear,
        String roleName,
        StudentProfileResponse profile
) {
}
