package prm393.se1911.assignment.myfschoolbackend.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import prm393.se1911.assignment.myfschoolbackend.model.response.StudentClubsResponse;
import prm393.se1911.assignment.myfschoolbackend.service.ClubService;

import java.util.UUID;

@RequestMapping("/api/v1/clubs")
@RestController
@RequiredArgsConstructor
public class ClubController {
    private final ClubService clubService;

    @GetMapping("/student")
    public ResponseEntity<StudentClubsResponse> getStudentClubs(@RequestParam UUID studentId) {
        return ResponseEntity.ok(clubService.getStudentClubs(studentId));
    }
}
