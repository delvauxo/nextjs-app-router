import postgres from 'postgres';
import axios from "axios";
import { formatCurrency } from './utils';
import {
  CustomerField,
  InvoicesTable,
} from './definitions';

const sql = postgres(process.env.POSTGRES_URL!, { ssl: 'require' });

// Récupère les données de revenu depuis l'API.
export async function fetchRevenue() {
  try {
    const response = await axios.get(`${process.env.API_BASE_URL}/revenue/`);
    return response.data;
  } catch (error) {
    throw new Error("Failed to fetch revenue data.");
  }
}

// Récupère et formate les dernières factures (montant et date) depuis l'API.
export async function fetchLatestInvoices() {
  try {
    const response = await axios.get(`${process.env.API_BASE_URL}/invoices/latest`);
    // Appliquer le formatage du montant et la date à chaque facture
    const formattedInvoices = response.data.map((invoice: any) => ({
      ...invoice,
      amount: formatCurrency(invoice.amount),
      date: new Date(invoice.date).toLocaleDateString('fr-FR')
    }));
    return formattedInvoices;
  } catch (error) {
    console.error("Failed to fetch the latest invoices:", error);
    return [];
  }
}

// Récupère en parallèle le nombre de factures, le nombre de clients et les montants des factures (paid et pending) depuis l'API.
export async function fetchCardData() {
  try {
    const invoiceCountPromise = axios
      .get(`${process.env.API_BASE_URL}/invoices/count`)
      .then(response => response.data.count);
    const customerCountPromise = axios
      .get(`${process.env.API_BASE_URL}/customers/count`)
      .then(response => response.data.count);
    const invoiceStatusPromise = axios
      .get(`${process.env.API_BASE_URL}/invoices/status`)
      .then(response => ({ paid: response.data.paid, pending: response.data.pending }));

    const data = await Promise.all([
      invoiceCountPromise,
      customerCountPromise,
      invoiceStatusPromise,
    ]);

    const numberOfInvoices = Number(data[0] ?? '0');
    const numberOfCustomers = Number(data[1] ?? '0');
    const totalPaidInvoices = formatCurrency(data[2].paid ?? '0');
    const totalPendingInvoices = formatCurrency(data[2].pending ?? '0');

    return {
      numberOfInvoices,
      numberOfCustomers,
      totalPaidInvoices,
      totalPendingInvoices,
    };
  } catch (error) {
    console.error('Database Error:', error);
    throw new Error('Failed to fetch card data.');
  }
}

// Doit correspondre au nombre d'item par page côté backend pour ne pas créer de désalignement.
const ITEMS_PER_PAGE = 6;

// Récupère les factures filtrées basée sur la query de la search-bar depuis l'API.
export async function fetchFilteredInvoices(query: string, currentPage: number): Promise<InvoicesTable[]> {
  try {
    const response = await axios.get(`${process.env.API_BASE_URL}/invoices`, {
      params: {
        query,
        page: currentPage,
        limit: ITEMS_PER_PAGE,
      },
    });

    return response.data as InvoicesTable[];
  } catch (error) {
    console.error("Error fetching filtered invoices:", error);
    throw new Error("Failed to fetch invoices.");
  }
}

// Récupère le nombre total de pages basé sur la recherche depuis l'API.
export async function fetchInvoicesPages(query: string): Promise<number> {
  try {
    const response = await axios.get(`${process.env.API_BASE_URL}/invoices/pages`, {
      params: { query },
    });
    return response.data.totalPages;
  } catch (error) {
    throw new Error('Failed to fetch total number of invoices.');
  }
}

// Récupère une facture spécifique par son identifiant depuis l'API.
export async function fetchInvoiceById(id: string) {
  try {
    const response = await axios.get(`${process.env.API_BASE_URL}/invoices/${id}`);

    if (!response.data) {
      throw new Error(`Invoice with ID ${id} not found.`);
    }

    const invoice = {
      ...response.data,
      amount: response.data.amount / 100
    };

    return invoice;
  } catch (error) {
    console.error(`Error fetching invoice ${id}:`, error);
    throw new Error('Failed to fetch invoice.');
  }
}

// Récupère la liste complète des clients via l'API.
export async function fetchCustomers() {
  try {
    const response = await axios.get(`${process.env.API_BASE_URL}/customers/all`);
    return response.data;
  } catch (err) {
    console.error('API Error fetching all customers:', err);
    throw new Error('Failed to fetch all customers.');
  }
}

// Récupère les clients filtrés en fonction de la recherche depuis la base de données.
export async function fetchFilteredCustomers(query: string, currentPage: number) {
  try {
    const response = await axios.get(`${process.env.API_BASE_URL}/customers/`, {
      params: { query, page: currentPage }
    });
    const data = response.data;
    // Traitement et formatage des montants avec formatCurrency
    const customers = data.map((customer: any) => ({
      ...customer,
      total_pending: formatCurrency(customer.total_pending),
      total_paid: formatCurrency(customer.total_paid),
    }));
    return customers;
  } catch (err) {
    console.error('API Error fetching filtered customers:', err);
    throw new Error('Failed to fetch filtered customers.');
  }
}

// Récupère le nombre total de pages pour les clients filtrés depuis la base de données.
export async function fetchCustomersPages(query: string): Promise<number> {
  try {
    const response = await axios.get(`${process.env.API_BASE_URL}/customers/count`, {
      params: { query }
    });
    const count = Number(response.data.count || 0);
    const pages = Math.ceil(count / ITEMS_PER_PAGE);
    return pages;
  } catch (error) {
    console.error("Failed to fetch customers pages:", error);
    throw new Error("Error fetching pages.");
  }
}