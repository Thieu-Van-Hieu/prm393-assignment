package prm393.se1911.assignment.myfschoolbackend.model.response;

import lombok.Builder;

@Builder
public record ClassResponse(
        String id,
        String className,
        String schoolYear
) {
}
