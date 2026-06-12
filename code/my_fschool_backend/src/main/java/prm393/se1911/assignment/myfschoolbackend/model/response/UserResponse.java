package prm393.se1911.assignment.myfschoolbackend.model.response;

import lombok.Builder;

import java.util.List;

@Builder
public record UserResponse(
        String id,
        String fullName,
        String phoneNumber,
        String email,
        String address,
        String roleName, // 'PARENT', 'STUDENT'
        StudentProfileResponse studentProfile,
        List<StudentProfileResponse> parentStudents
) {
}