// @ts-nocheck
import { marked } from 'marked';
import DOMPurify from 'dompurify';

/**
 * @param {string} text
 */
export function formatMessage(text) {
    // Convert markdown to HTML
    let formattedText = marked.parse(text);

    // Sanitize the HTML
    return DOMPurify.sanitize(formattedText);
}
