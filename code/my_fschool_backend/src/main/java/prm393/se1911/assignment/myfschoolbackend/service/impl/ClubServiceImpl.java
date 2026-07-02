package prm393.se1911.assignment.myfschoolbackend.service.impl;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import prm393.se1911.assignment.myfschoolbackend.entity.Club;
import prm393.se1911.assignment.myfschoolbackend.model.response.ClubResponse;
import prm393.se1911.assignment.myfschoolbackend.model.response.StudentClubsResponse;
import prm393.se1911.assignment.myfschoolbackend.repository.ClubMemberRepository;
import prm393.se1911.assignment.myfschoolbackend.repository.ClubRepository;
import prm393.se1911.assignment.myfschoolbackend.service.ClubService;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ClubServiceImpl implements ClubService {

    private final ClubRepository clubRepository;
    private final ClubMemberRepository clubMemberRepository;

    private List<ClubResponse> getJoinedClubs(UUID studentId) {
        final var clubMembers = clubMemberRepository.getAllByStudentId(studentId);
        return clubMembers.stream().map(clubMember -> toClubResponse(clubMember.getClub())).toList();
    }

    private List<ClubResponse> getUnjoinedClubs(UUID studentId) {
        final var clubs = clubRepository.findAllByIdNotIn(getJoinedClubs(studentId).stream().map(ClubResponse::id).toList());
        return clubs.stream().map(this::toClubResponse).toList();
    }

    @Override
    public StudentClubsResponse getStudentClubs(UUID studentId) {
        return new StudentClubsResponse(getJoinedClubs(studentId), getUnjoinedClubs(studentId));
    }

    private ClubResponse toClubResponse(Club club) {
        return ClubResponse.builder()
                .id(club.getId())
                .clubName(club.getClubName())
                .description(club.getDescription())
                .base64Image(club.getBase64Image())
                .schedules(club.getSchedules())
                .build();
    }
}
