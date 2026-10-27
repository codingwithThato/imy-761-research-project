/**
 * Builds the post-play questionnaire as a Google Form, plus a linked
 * Google Sheet that collects the responses.
 *
 * How to run:
 *   1. Go to https://script.google.com and click "New project".
 *   2. Delete the placeholder code, paste this whole file in, and save.
 *   3. Pick "createPostPlayForm" in the function dropdown and click Run.
 *   4. Approve the permissions prompt (it needs access to Forms and Sheets).
 *   5. Open View -> Logs (or Execution log) to get the links.
 *
 * Item wording matches materials/post-play-questionnaire.md word for word.
 * Don't change it: keeping the BANGS/GEQ items verbatim is what keeps the
 * instruments valid. Scoring is in post-play-questionnaire-scoring-key.md.
 */
function createPostPlayForm() {
  var form = FormApp.create('Post-Play Questionnaire');

  form.setDescription(
    'Please answer the questions below based on how you felt while playing the game.\n' +
    'There are no right or wrong answers — just answer as honestly as you can.'
  );
  form.setCollectEmail(false);          // keep responses anonymous
  form.setAllowResponseEdits(false);
  form.setShowLinkToRespondAgain(true); // next participant can use the same device
  form.setProgressBar(true);
  form.setConfirmationMessage('Thank you for your answers.');

  form.addTextItem()
    .setTitle('Participant no.')
    .setHelpText('The researcher will tell you this number.')
    .setRequired(true);

  // Part 1: 1–7 agreement scale (items 1–6)
  form.addPageBreakItem()
    .setTitle('Part 1')
    .setHelpText('For each statement, choose a number from 1 (Strongly disagree) to 7 (Strongly agree).');

  [
    'I felt competent at the game.',
    'I felt incapable while playing.',
    'I successfully completed challenges in the game.',
    'I felt like a failure when I played.',
    'I felt capable while playing.',
    'The game made me doubt my ability.'
  ].forEach(function (text, i) {
    form.addScaleItem()
      .setTitle((i + 1) + '. ' + text)
      .setBounds(1, 7)
      .setLabels('Strongly disagree', 'Strongly agree')
      .setRequired(true);
  });

  // Part 2: 0–4 intensity scale (items 7–9)
  form.addPageBreakItem()
    .setTitle('Part 2')
    .setHelpText('For each statement, choose a number from 0 (Not at all) to 4 (Extremely).');

  [
    'I felt frustrated.',
    'I felt annoyed.',
    'I felt irritable.'
  ].forEach(function (text, i) {
    form.addScaleItem()
      .setTitle((i + 7) + '. ' + text)
      .setBounds(0, 4)
      .setLabels('Not at all', 'Extremely')
      .setRequired(true);
  });

  var sheet = SpreadsheetApp.create('Post-Play Questionnaire (Responses)');
  form.setDestination(FormApp.DestinationType.SPREADSHEET, sheet.getId());

  Logger.log('Share with participants: ' + form.getPublishedUrl());
  Logger.log('Edit the form:           ' + form.getEditUrl());
  Logger.log('Responses sheet:         ' + sheet.getUrl());
}
