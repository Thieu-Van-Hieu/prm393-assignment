package prm393.se1911.assignment.myfschoolbackend.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import prm393.se1911.assignment.myfschoolbackend.model.response.SemesterTranscriptResponse;
import prm393.se1911.assignment.myfschoolbackend.service.TranscriptService;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/transcripts")
@RequiredArgsConstructor
public class TranscriptController {

    private final TranscriptService transcriptService;

    @GetMapping
    public ResponseEntity<List<SemesterTranscriptResponse>> getTranscript(
            @RequestParam UUID studentId) {

        List<SemesterTranscriptResponse> transcript = transcriptService.getSemesterTranscripts(studentId);
        return ResponseEntity.ok(transcript);
    }
}