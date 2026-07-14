package prm393.se1911.assignment.myfschoolbackend.controller;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import prm393.se1911.assignment.myfschoolbackend.model.request.EventRegistrationRequest;
import prm393.se1911.assignment.myfschoolbackend.model.response.EventResponse;
import prm393.se1911.assignment.myfschoolbackend.service.EventService;
import prm393.se1911.assignment.myfschoolbackend.util.SessionUtils;

import java.util.List;
import java.util.UUID;

@RequestMapping("/api/v1/events")
@RestController
@RequiredArgsConstructor
public class EventController {

    private final EventService eventService;

    @GetMapping
    public ResponseEntity<List<EventResponse>> getEvents(HttpSession session) {
        return ResponseEntity.ok(eventService.getAllEvents(SessionUtils.getUserIdFromSession(session)));
    }

    @PostMapping("/register")
    public ResponseEntity<Void> registerEvent(@RequestBody EventRegistrationRequest eventRegistrationRequest, HttpSession session) {
        UUID userId = SessionUtils.getUserIdFromSession(session);
        eventService.registerEvent(userId, eventRegistrationRequest);
        return ResponseEntity.ok().build();
    }
}
