//= encoding UTF-8
//  assume jquery
//  assume digivol-image-resize

var shouldRefresh = true;
var refreshTime = 30000;

var thumbnails = $('.quickPreview');
for (var thumbnailIndex = 0; thumbnailIndex < thumbnails.length; thumbnailIndex++) {
    thumbnails[thumbnailIndex].addEventListener('mousemove', function (e) {
        var zoomDiv = e.currentTarget;
        var offsetX, offsetY, x, y;
        e.offsetX ? offsetX = e.offsetX : offsetX = e.touches[0].pageX
        e.offsetY ? offsetY = e.offsetY : offsetX = e.touches[0].pageX
        x = offsetX / zoomDiv.offsetWidth * 100
        y = offsetY / zoomDiv.offsetHeight * 100
        zoomDiv.style.backgroundPosition = x + '% ' + y + '%';
    })
}

var previewButtons = $('.btnPreview');
for (var buttonIndex = 0; buttonIndex < previewButtons.length; buttonIndex++) {
    var button = previewButtons[buttonIndex];
    var taskId = button.id;
    button.addEventListener('click', function () {
        $('.btnPreview').attr('disabled', true);
        $(this).addClass('loading');
    });

    button.addEventListener('click', function () {
        shouldRefresh = false;
        bvp.showModal({
            url: '/overview/preview?taskId=' + this.id,
            size: 'large',
            title: 'Task preview',
            buttons: {
                close: {
                    label: 'Close',
                    className: 'btn-default'
                }
            },
            onClose: function () {
                shouldRefresh = true;
            },
            onShown: function () {
                var btn = $('.btnPreview');
                btn.removeClass('loading');
                btn.removeAttr('disabled');
            },
            onContentLoaded: function () {
                setupPanZoom($('#previewBlock img')[0]);
            }
        });

    })
}

// Won't refresh if the preview modal is opened
function refresh() {
    if (shouldRefresh) {
        location.reload();
    }
    setTimeout(refresh, refreshTime);
}

setTimeout(refresh, refreshTime);
