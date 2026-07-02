import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_fschool_frontend/model/request/event_registration_request.dart';
import 'package:my_fschool_frontend/model/response/event_response.dart';
import 'package:my_fschool_frontend/notifier/event_notifier.dart';
import 'package:my_fschool_frontend/widget/event/event_card.dart'; // Import card mới tách
import 'package:my_fschool_frontend/widget/event/register_event_sheet_content.dart';
import 'package:my_fschool_frontend/widget/input/app_bottom_sheet.dart';

class EventScreen extends HookConsumerWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(eventProvider);

    useEffect(() {
      Future.microtask(() => ref.read(eventProvider.notifier).fetchEvents());
      return null;
    }, []);

    return eventsAsync.when(
      data: (events) {
        if (events.isEmpty) {
          return const Center(
            child: Text(
              'Hiện tại chưa có sự kiện nào.',
              style: TextStyle(
                fontFamily: 'Asap',
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFFFF5722),
          onRefresh: () =>
              ref.read(eventProvider.notifier).fetchEvents(isSilent: true),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];

              return EventCard(
                event: event,
                onRegisterPressed: () =>
                    _openRegisterSheet(context, ref, event),
              );
            },
          ),
        );
      },
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFFFF5722)),
      ),
      error: (err, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Đã xảy ra lỗi khi tải danh sách sự kiện 😢',
                style: TextStyle(
                  fontFamily: 'Asap',
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                err.toString().replaceAll('Exception: ', ''),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.read(eventProvider.notifier).fetchEvents(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                ),
                child: const Text(
                  'Thử lại',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openRegisterSheet(
    BuildContext context,
    WidgetRef ref,
    EventResponse event,
  ) {
    final rootContext = context;

    AppBottomSheet.show(
      context: context,
      title: 'Đơn đăng ký',
      content: RegisterEventSheetContent(
        eventTitle: event.title,
        onSubmit: ({required memberCount, required note}) async {
          final request = EventRegistrationRequest(
            eventId: event.id,
            numberOfTickets: memberCount,
            notes: note,
          );

          await ref
              .read(eventProvider.notifier)
              .registerEvent(eventRegistrationRequest: request);

          if (rootContext.mounted) {
            Navigator.of(rootContext).pop();
            ScaffoldMessenger.of(rootContext).showSnackBar(
              const SnackBar(
                content: Text('Đăng ký tham gia sự kiện thành công! 🎉'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }
}
