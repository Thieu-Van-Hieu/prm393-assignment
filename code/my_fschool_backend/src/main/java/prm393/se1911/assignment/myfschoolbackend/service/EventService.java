package prm393.se1911.assignment.myfschoolbackend.service;

import prm393.se1911.assignment.myfschoolbackend.model.request.EventRegistrationRequest;
import prm393.se1911.assignment.myfschoolbackend.model.response.EventResponse;

import java.util.List;
import java.util.UUID;

public interface EventService {
    List<EventResponse> getAllEvents(UUID parentId);

    void registerEvent(UUID parentId, EventRegistrationRequest request);
}
