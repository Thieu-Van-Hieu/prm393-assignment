package prm393.se1911.assignment.myfschoolbackend.model.response;

import java.util.List;

public record StudentClubsResponse(
        List<ClubResponse> joinedClubs,
        List<ClubResponse> unjoinedClubs
) {
}
