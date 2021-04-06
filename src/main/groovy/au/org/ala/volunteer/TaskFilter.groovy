package au.org.ala.volunteer

enum TaskFilter {

    showAll("taskFilterType.showAll"),
    showReadyForTranscription("taskFilterType.readyForTranscription"),
    showTranscriptionLocked("taskFilterType.transcriptionLocked")

    String i18nLabel

    TaskFilter(String i18nLabel) {
        this.i18nLabel = i18nLabel
    }

}
