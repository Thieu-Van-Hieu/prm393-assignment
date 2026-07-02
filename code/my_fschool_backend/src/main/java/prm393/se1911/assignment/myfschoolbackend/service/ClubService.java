package prm393.se1911.assignment.myfschoolbackend.service;

import prm393.se1911.assignment.myfschoolbackend.model.response.StudentClubsResponse;

import java.util.UUID;

public interface ClubService {
    StudentClubsResponse getStudentClubs(UUID studentId);
}
