package prm393.se1911.assignment.myfschoolbackend.service;

import prm393.se1911.assignment.myfschoolbackend.model.response.SemesterTranscriptResponse;

import java.util.List;
import java.util.UUID;

public interface TranscriptService {
    List<SemesterTranscriptResponse> getSemesterTranscripts(UUID studentId);
}
