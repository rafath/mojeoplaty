function submitForm() {
  if ($('.upload-form').length) {
    $('.upload-form')
        .submit(function (e) {
          e.preventDefault();
          $.ajax({
            url: $(this).attr('action'),
            type: 'POST',
            data: new FormData(this),
            processData: false,
            contentType: false
          });
        });
  }
}
function uploadPayroll() {
  if ($('.upload-payroll').length) {
    $('.upload-payroll').change(function () {
      $(this).closest('form').submit();
    })
  }
}
function niceInputFile() {
  if ($('.id-input-file').length) {
    $('.id-input-file').ace_file_input({
      no_file: 'Brak wybranych plików',
      btn_choose: 'wybierz',
      btn_change: 'zmień',
      droppable: false,
      thumbnail: false //| true | large
      //whitelist: ['csv']
    });
  }
}
function setDisabled() {
  if ($('.set_disabled').length) {
    $('.set_disabled').click(function() {
      e = $(this);
      e.addClass('disabled');
      setTimeout("e.removeClass('disabled');", 5000);
    });
  }
}

function loadDataTable() {
  if ($('#data_table').length) {
    $('#data_table').DataTable({
      ordering: false,
      dom: 'fl<t>lp',
      //paging: false,
      pageLength: 100,
      language: {
        info: "Ilość rekordów _TOTAL_, aktualnie wyświetlam od _START_ do _END_",
        infoEmpty: "Brak rekordów",
        lengthMenu:  "Pokaż _MENU_ rekordów",
        infoFiltered: " - filtruję z _MAX_ rekordów",
        loadingRecords: "Proszę czekać, ładuję dane...",
        search: "Znajdź firmę _INPUT_",
        zeroRecords: "Brak rekordów",
        paginate: {
          first:      "pierwsza",
          previous:   "poprzednia",
          next:       "następna",
          last:       "ostatnia"
        },
      }
    });
  }
}

function loadOnLoad() {
  $('.formtastic').valtastic();
  niceInputFile();
  submitForm();
  uploadPayroll();
  loadDataTable();
  setDisabled();
}

$(document).ready(function () {
//    $colorboxOverlay = $('#cboxOverlay');
//    $colorboxBox = $('#colorbox');
  loadOnLoad();
});
//$(document).on('page:load', function () {
////    $colorboxOverlay.appendTo('body');
////    $colorboxBox.appendTo('body');
//  loadOnLoad();
//});
